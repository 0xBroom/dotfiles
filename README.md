# dotfiles

Configuración portable de **Neovim (lazy.nvim) + tmux + zsh (oh-my-zsh + powerlevel10k)**.
Misma config en macOS, Linux y WSL. Un solo comando para levantar cualquier máquina.

## Filosofía

Se versiona **la receta, no los ingredientes**:

- ✅ Se versiona: tus configs (`.zshrc`, `.p10k.zsh`, `.tmux.conf`, `~/.config/nvim`) y el `lazy-lock.json`.
- ❌ No se versiona: `oh-my-zsh`, los plugins de zsh/tmux/nvim. Los reinstala `install.sh`, TPM y lazy.

Los **symlinks** los maneja [GNU Stow](https://www.gnu.org/software/stow/): la config vive en este repo y Stow la enlaza a `$HOME`.

## Instalación en una máquina nueva

```sh
git clone https://github.com/<TU_USUARIO>/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

En un servidor/nube sin pantalla (solo SSH), saltea la fuente:

```sh
./install.sh --no-font
```

## Estructura (Stow)

```
dotfiles/
├── install.sh              # detecta SO, instala herramientas + fonts, corre stow
├── zsh/   .zshrc  .p10k.zsh
├── tmux/  .tmux.conf
└── nvim/  .config/nvim/    # incluye lazy-lock.json (versiones fijas de plugins)
```

Cada carpeta es un "paquete" Stow: su interior refleja la ruta relativa a `$HOME`.

## Nerd Font

La fuente (**MesloLGS NF**) la renderiza el terminal que tenés **enfrente**, no el host remoto.
`install.sh` la instala solo en máquinas con entorno gráfico. Después seleccionala en tu
emulador (iTerm2 / WezTerm / Windows Terminal / Ghostty).

## Editar la config

Como son symlinks, editás en `~/.config/nvim` (o donde sea) y estás editando el repo.
Luego: `cd ~/dotfiles && git add -A && git commit && git push`.
