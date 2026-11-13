# ~/.zshenv: read by EVERY zsh, including non-interactive ones (ssh host cmd,
# mosh-server, scripts). Keep it minimal, fast, and silent: PATH only.

# Homebrew on PATH (Apple Silicon: /opt/homebrew, Intel: /usr/local). No-op elsewhere.
# Needed so `mosh host` finds mosh-server on a remote Mac.
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  [[ -x $_brew ]] && { eval "$($_brew shellenv)"; break; }
done
unset _brew

# Rust (rustup).
if [[ -f "$HOME/.cargo/env" ]]; then . "$HOME/.cargo/env"; fi
