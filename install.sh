#!/usr/bin/env bash
#
# Bootstrap de dotfiles: nvim + tmux + zsh (oh-my-zsh + powerlevel10k)
#
# CONCEPTO: este script instala las HERRAMIENTAS y frameworks (que difieren
# por SO), y luego Stow crea los symlinks de tus configs (que son idénticas).
# Es idempotente: podés correrlo varias veces sin romper nada.
#
#   Uso:  ./install.sh            # instala todo + fonts si hay entorno gráfico
#         ./install.sh --no-font  # fuerza saltear la Nerd Font (server/SSH)
#
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
INSTALL_FONT=1
[[ "${1:-}" == "--no-font" ]] && INSTALL_FONT=0

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[!]\033[0m %s\n' "$*"; }

# ---------------------------------------------------------------------------
# 1. Detectar SO y elegir gestor de paquetes
# ---------------------------------------------------------------------------
OS="unknown"
case "$(uname -s)" in
  Darwin) OS="macos" ;;
  Linux)  OS="linux" ;;
esac
IS_WSL=0
grep -qi microsoft /proc/version 2>/dev/null && IS_WSL=1
log "SO detectado: $OS$([[ $IS_WSL == 1 ]] && echo ' (WSL)')"

# Sin entorno gráfico (típico server en la nube / SSH) => no tiene sentido la font
if [[ $INSTALL_FONT == 1 && "$OS" == "linux" && -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
  warn "Sin entorno gráfico: salteo la Nerd Font (la renderiza tu terminal local, no este host)."
  INSTALL_FONT=0
fi

# ---------------------------------------------------------------------------
# 2. Instalar paquetes base
#    git zsh tmux neovim ripgrep fd stow curl unzip (+ fontconfig en linux)
# ---------------------------------------------------------------------------
install_packages() {
  if [[ "$OS" == "macos" ]]; then
    if ! command -v brew >/dev/null 2>&1; then
      log "Instalando Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    log "Instalando paquetes con brew..."
    brew install git zsh tmux neovim ripgrep fd stow curl
  elif [[ "$OS" == "linux" ]]; then
    if command -v apt-get >/dev/null 2>&1; then
      log "Instalando paquetes con apt..."
      sudo apt-get update -y
      # fd se llama fd-find en Debian/Ubuntu; ripgrep = ripgrep
      sudo apt-get install -y git zsh tmux ripgrep fd-find stow curl unzip fontconfig build-essential
      # neovim de apt suele estar viejo -> preferimos el appimage/repo oficial si falta o es < 0.9
      if ! command -v nvim >/dev/null 2>&1; then
        warn "Instalando Neovim (unstable PPA para versión reciente)..."
        sudo apt-get install -y software-properties-common
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt-get update -y && sudo apt-get install -y neovim
      fi
      # alias fd -> fdfind si hace falta
      if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
        mkdir -p "$HOME/.local/bin"; ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
      fi
    else
      warn "No encontré apt-get. Instalá manualmente: git zsh tmux neovim ripgrep fd stow."
    fi
  fi
}
install_packages

# ---------------------------------------------------------------------------
# 3. oh-my-zsh (framework — NO está en el repo, se instala acá)
# ---------------------------------------------------------------------------
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Instalando oh-my-zsh..."
  RUNZSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  log "oh-my-zsh ya presente."
fi

# ---------------------------------------------------------------------------
# 4. Plugins/tema de terceros de zsh (clonados, NO versionados)
# ---------------------------------------------------------------------------
clone_or_pull() { # $1=repo url  $2=destino
  if [[ -d "$2" ]]; then
    git -C "$2" pull --ff-only --quiet || true
  else
    git clone --depth=1 "$1" "$2"
  fi
}
log "Instalando plugins/tema de zsh..."
clone_or_pull https://github.com/romkatv/powerlevel10k.git            "$ZSH_CUSTOM/themes/powerlevel10k"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions.git    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

# ---------------------------------------------------------------------------
# 5. TPM para tmux (los plugins los instala TPM, no el repo)
# ---------------------------------------------------------------------------
log "Instalando TPM (tmux plugin manager)..."
clone_or_pull https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"

# ---------------------------------------------------------------------------
# 6. Nerd Font (MesloLGS NF — la que recomienda powerlevel10k)
#    Solo tiene sentido donde hay una pantalla que renderice el terminal.
# ---------------------------------------------------------------------------
install_font() {
  [[ $INSTALL_FONT == 0 ]] && { log "Salteo Nerd Font."; return; }
  if [[ "$OS" == "macos" ]]; then
    log "Instalando MesloLGS Nerd Font con brew..."
    brew install --cask font-meslo-lg-nerd-font || warn "No pude instalar la font por brew."
  else
    log "Instalando MesloLGS Nerd Font en ~/.local/share/fonts ..."
    local dir="$HOME/.local/share/fonts"; mkdir -p "$dir"
    local base="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
    local tmp; tmp="$(mktemp -d)"
    if curl -fsSL "$base" -o "$tmp/Meslo.zip"; then
      unzip -o -q "$tmp/Meslo.zip" -d "$dir"
      fc-cache -f "$dir" >/dev/null 2>&1 || true
    else
      warn "No pude bajar la Nerd Font. Instalala a mano si querés iconos."
    fi
    rm -rf "$tmp"
  fi
  warn "IMPORTANTE: seleccioná 'MesloLGS NF' en tu emulador de terminal (iTerm2/WezTerm/Windows Terminal)."
}
install_font

# ---------------------------------------------------------------------------
# 7. Symlinks con Stow (config idéntica en todas las máquinas)
#    Hace backup de cualquier archivo real que estorbe antes de symlinkear.
# ---------------------------------------------------------------------------
backup_if_real() { # respalda un path si es archivo/dir real (no symlink)
  local p="$1"
  if [[ -e "$p" && ! -L "$p" ]]; then
    local bak="$p.pre-dotfiles.$(date +%Y%m%d%H%M%S)"
    warn "Respaldo $p -> $bak"
    mv "$p" "$bak"
  fi
}
log "Creando symlinks con stow..."
cd "$DOTFILES_DIR"
# ~/.config DEBE existir antes de stow: si no, stow "foldea" y symlinkea ~/.config
# entero al repo (peligroso: otras apps escribirían dentro de tus dotfiles).
mkdir -p "$HOME/.config"
backup_if_real "$HOME/.zshrc"
backup_if_real "$HOME/.p10k.zsh"
backup_if_real "$HOME/.tmux.conf"
backup_if_real "$HOME/.config/nvim"
stow --target="$HOME" --restow zsh tmux nvim

# ---------------------------------------------------------------------------
# 8. Instalar plugins de nvim (headless, según lazy-lock.json) y tmux
# ---------------------------------------------------------------------------
if command -v nvim >/dev/null 2>&1; then
  log "Sincronizando plugins de Neovim (lazy)..."
  nvim --headless "+Lazy! restore" +qa 2>/dev/null || \
  nvim --headless "+Lazy! sync"    +qa 2>/dev/null || \
  warn "Abrí nvim manualmente para que lazy instale los plugins."
fi
log "Instalando plugins de tmux (TPM)..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1 || \
  warn "Abrí tmux y presioná <prefix> + I para instalar los plugins."

# ---------------------------------------------------------------------------
# 9. zsh como shell por defecto
# ---------------------------------------------------------------------------
ZSH_BIN="$(command -v zsh)"
if [[ "$SHELL" != "$ZSH_BIN" ]]; then
  log "Cambiando shell por defecto a zsh..."
  # chsh sin sudo pide password por PAM y falla en cuentas sin contraseña;
  # vía sudo (como root) no dispara ese prompt.
  sudo chsh -s "$ZSH_BIN" "$(whoami)" 2>/dev/null \
    || chsh -s "$ZSH_BIN" 2>/dev/null \
    || warn "No pude cambiar la shell. Hacelo con: chsh -s $ZSH_BIN"
fi

log "Listo. Abrí una terminal nueva. Si p10k pide config: p10k configure (o ya viene de tu .p10k.zsh)."
