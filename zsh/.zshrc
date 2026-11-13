# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Homebrew on PATH (Apple Silicon: /opt/homebrew, Intel: /usr/local). No-op elsewhere.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $_brew ]] && { eval "$($_brew shellenv)"; break; }
done
unset _brew

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	z
	sudo
	extract
	command-not-found
	colored-man-pages
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# Language environment: seteá UTF-8 solo si no viene ya definido
# (evita cuadraditos en servers cloud sin locale, sin pisar el locale local).
export LANG="${LANG:-en_US.UTF-8}"

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export VISUAL='nvim'

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---------------------------------------------------------------------------
# macOS only.
# ---------------------------------------------------------------------------
if [[ "$OSTYPE" == darwin* ]]; then
  # ffmpeg helper: convert a video to an optimized gif (needs ffmpeg + gifsicle).
  video_to_gif() {
    ffmpeg -i "$1" -vf "fps=10,scale=480:-1:flags=lanczos" -pix_fmt rgb8 -r 10 -f gif - | \
      gifsicle --optimize=3 --colors 64 --lossy=80 -o "${1%.*}.gif" && \
      osascript -e "display notification \"${1%.*}.gif successfully converted and saved\" with title \"MOV2GIF SUCCESS!\""
  }

  # Powerlevel10k: follow macOS light/dark appearance.
  # Dark keeps ~/.p10k.zsh as is; light remaps its 256-color palette to Catppuccin Latte.
  zmodload zsh/datetime
  typeset -gA _p10k_latte=(
    238 '#ccd0da' 246 '#9ca0b0'
    255 '#4c4f69' 248 '#5c5f77' 244 '#6c6f85' 242 '#7c7f93'
    31 '#1e66f5' 32 '#1e66f5' 33 '#1e66f5' 38 '#1e66f5' 39 '#1e66f5' 74 '#1e66f5'
    81 '#209fb5' 110 '#209fb5' 117 '#209fb5' 67 '#7287fd' 68 '#7287fd' 103 '#7287fd'
    96 '#8839ef' 99 '#8839ef' 129 '#8839ef' 134 '#8839ef' 135 '#8839ef'
    34 '#40a02b' 35 '#40a02b' 70 '#40a02b' 72 '#40a02b' 76 '#40a02b' 106 '#40a02b'
    37 '#179299' 66 '#179299'
    178 '#df8e1d' 180 '#df8e1d' 220 '#df8e1d'
    94 '#fe640b' 130 '#fe640b' 166 '#fe640b' 172 '#fe640b' 208 '#fe640b'
    125 '#d20f39' 160 '#d20f39' 161 '#d20f39' 196 '#d20f39' 168 '#ea76cb'
  )
  typeset -g _p10k_appearance= _p10k_appearance_checked=0

  _p10k_detect_appearance() {
    [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == Dark ]] && print dark || print light
  }

  _p10k_apply_appearance() {
    local mode=$1 name value
    source ~/.p10k.zsh                      # restore the dark (original) config
    if [[ $mode == light ]]; then
      for name in ${(k)parameters[(I)POWERLEVEL9K_*(FOREGROUND|BACKGROUND)]}; do
        value=${(P)name}
        [[ -n $value && -n ${_p10k_latte[$value]} ]] && typeset -g $name=${_p10k_latte[$value]}
      done
      typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR='%F{#9ca0b0}\uE0B1'
      typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR='%F{#9ca0b0}\uE0B3'
    fi
    _p10k_appearance=$mode
  }

  # Re-check at most every 3 seconds so open shells follow the system switch.
  _p10k_appearance_precmd() {
    (( EPOCHSECONDS - _p10k_appearance_checked < 3 )) && return
    _p10k_appearance_checked=$EPOCHSECONDS
    local mode=$(_p10k_detect_appearance)
    [[ $mode == $_p10k_appearance ]] && return
    _p10k_apply_appearance $mode
    (( $+functions[p10k] )) && p10k reload
  }

  if [[ -f ~/.p10k.zsh ]]; then
    _p10k_appearance_checked=$EPOCHSECONDS
    _p10k_apply_appearance $(_p10k_detect_appearance)
    autoload -Uz add-zsh-hook
    add-zsh-hook precmd _p10k_appearance_precmd
  fi
fi

# ---------------------------------------------------------------------------
# Config ESPECIFICA DE ESTA MAQUINA (no versionada).
#
# CONCEPTO: este .zshrc se comparte entre macOS, Linux y WSL, asi que solo
# puede contener lo que aplica en TODAS. Lo que depende de la maquina
# (runtimes, SDKs, herramientas del equipo) va en ~/.zshrc.local, que no
# esta en el repo. Va al final para que pueda pisar cualquier cosa de arriba.
#
# Ver zshrc.local.example como plantilla.
# ---------------------------------------------------------------------------
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# direnv: loads per-directory .envrc files (e.g. multi-account gh).
if command -v direnv >/dev/null 2>&1; then
  export DIRENV_LOG_FORMAT=""   # keep direnv quiet: p10k instant prompt hates console output
  eval "$(direnv hook zsh)"
fi

# worktrunk (wt) shell integration.
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
