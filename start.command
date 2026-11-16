#!/bin/zsh
# Double-click to start LilyKeys and open it in your browser.
# On a new computer it runs setup.command first to install what LilyKeys needs.
cd "$(dirname "$0")"
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
if ! command -v node >/dev/null 2>&1 || ! command -v lilypond >/dev/null 2>&1 || ! command -v claude >/dev/null 2>&1; then
  echo "Some of what LilyKeys needs is missing on this computer. Running setup first…"
  LILYKEYS_FROM_START=1 /bin/bash ./setup.command
fi
exec node server.js --open
