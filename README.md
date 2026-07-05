# dotfiles

Portable terminal environment: **Neovim (lazy.nvim) + tmux (TPM) + zsh (oh-my-zsh + powerlevel10k)**.
One command bootstraps a fresh machine. Same config on macOS, Linux, and WSL.

## Install

```sh
git clone git@github.com:0xBroom/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh              # headless/SSH box: ./install.sh --no-font
```

`install.sh` is idempotent — safe to re-run. Existing dotfiles are backed up
(`*.pre-dotfiles.<timestamp>`) before symlinking.

## What it does

1. Detects OS (macOS / Linux-apt / WSL) and installs tools via `brew` or `apt`:
   `git zsh tmux neovim ripgrep fd stow`.
2. Installs oh-my-zsh, then clones the third-party zsh pieces:
   `powerlevel10k`, `zsh-autosuggestions`, `zsh-syntax-highlighting`.
3. Installs TPM and the MesloLGS Nerd Font (skipped on headless hosts).
4. `stow`s the config packages into `$HOME`.
5. Restores Neovim plugins headless (`Lazy! restore`, pinned by `lazy-lock.json`)
   and installs tmux plugins via TPM.
6. Sets zsh as the default shell.

## Design

Version the recipe, not the ingredients:

- **Tracked**: config files + `lazy-lock.json` (pinned plugin versions).
- **Not tracked**: oh-my-zsh, zsh/tmux/nvim plugins — reinstalled by `install.sh`, TPM, and lazy.

Symlinks are managed by [GNU Stow](https://www.gnu.org/software/stow/). Each top-level
folder is a Stow package whose layout mirrors its target path under `$HOME`:

```
dotfiles/
├── install.sh
├── zsh/    .zshrc  .p10k.zsh          -> ~/.zshrc, ~/.p10k.zsh
├── tmux/   .tmux.conf                 -> ~/.tmux.conf
└── nvim/   .config/nvim/              -> ~/.config/nvim/  (incl. lazy-lock.json)
```

## Nerd Font

Glyphs are rendered by the terminal in front of you, **not** the remote host, so
`install.sh` only installs the font on machines with a display. Select **MesloLGS NF**
in your terminal emulator (iTerm2 / WezTerm / Ghostty / Windows Terminal).

## Editing config

Files are symlinks into this repo, so edit in place (`~/.config/nvim`, `~/.zshrc`, …)
and commit from `~/dotfiles`.
