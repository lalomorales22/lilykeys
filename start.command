#!/bin/zsh
# Double-click to start LilyKeys and open it in your browser.
cd "$(dirname "$0")"
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"
exec node server.js --open
