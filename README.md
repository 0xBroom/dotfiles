# dotfiles

Portable terminal environment: **Neovim (lazy.nvim) + tmux (TPM) + zsh (oh-my-zsh + powerlevel10k)**.
One command bootstraps a fresh machine. Same config on macOS, Linux, and WSL.

## Install

```sh
xcode-select --install    # macOS only: provides git on a fresh Mac
git clone https://github.com/0xBroom/dotfiles.git ~/dotfiles   # HTTPS: no SSH key yet
cd ~/dotfiles
./install.sh              # headless/SSH box: ./install.sh --no-font
```

`install.sh` is idempotent — safe to re-run. Existing dotfiles are backed up
(`*.pre-dotfiles.<timestamp>`) before symlinking.

## What it does

1. Detects OS (macOS / Linux-apt / WSL) and installs tools via `brew` or `apt`:
   `git zsh tmux neovim ripgrep fd stow`. On macOS it then runs `brew bundle`
   with the repo's `Brewfile` (CLI tools and apps; a failing entry only warns).
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
├── Brewfile                           (macOS packages, not stowed)
├── zsh/    .zshrc  .p10k.zsh          -> ~/.zshrc, ~/.p10k.zsh
├── tmux/   .tmux.conf                 -> ~/.tmux.conf
├── nvim/   .config/nvim/              -> ~/.config/nvim/  (incl. lazy-lock.json)
├── ghostty/ .config/ghostty/config     -> ~/.config/ghostty/config
└── herdr/  .config/herdr/config.toml  -> ~/.config/herdr/config.toml  (keys, theme)
```

## Machine-specific config

`zsh/.zshrc` is shared across macOS, Linux, and WSL, so it may only contain what
applies everywhere. Anything machine-bound — local runtimes, cloud SDKs, personal
helper scripts — goes in `~/.zshrc.local`, which is **not** tracked. The tracked
`.zshrc` sources it last, so it can override anything above it:

```sh
cp zshrc.local.example ~/.zshrc.local   # then edit
```

Guard every block with an existence check (`[ -f ... ] && source ...`) so the same
file stays harmless on a machine where the tool isn't installed.

## After install (manual, per machine)

Secrets never live in this repo (public or not). Set them up by hand or pull them
from a password manager (e.g. `op read ...` with the 1Password CLI):

1. SSH key: create one (`ssh-keygen -t ed25519`) or restore it from your password
   manager, then add it to GitHub.
2. GitHub CLI: `gh auth login`.
3. Git identity: `git config --global user.name ...` and `user.email ...`.
4. Node: install [nvm](https://github.com/nvm-sh/nvm), then `nvm install --lts` and
   the global packages you use (`npm i -g ...`).
5. `cp zshrc.local.example ~/.zshrc.local` and adapt it (JDK, SDKs, tool PATHs).
6. Switch the repo remote to SSH once the key works:
   `git -C ~/dotfiles remote set-url origin git@github.com:0xBroom/dotfiles.git`.

To refresh the `Brewfile` from the current machine:
`brew bundle dump --file=~/dotfiles/Brewfile --force`, then review the diff.

## Nerd Font

Glyphs are rendered by the terminal in front of you, **not** the remote host, so
`install.sh` only installs the font on machines with a display. Select **MesloLGS Nerd Font Mono**
in your terminal emulator (Ghostty already sets it in its config).

## Editing config

Files are symlinks into this repo, so edit in place (`~/.config/nvim`, `~/.zshrc`, …)
and commit from `~/dotfiles`.
