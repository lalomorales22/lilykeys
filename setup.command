#!/bin/bash
# LilyKeys setup. Double-click this file (or run ./setup.command) to install everything LilyKeys needs:
# Homebrew, Node.js, LilyPond, Claude Code, and the orchestra and band instrument sounds.
# It is safe to run again: anything already installed is left alone.
cd "$(dirname "$0")" || exit 1
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

bold() { printf '\n\033[1m%s\033[0m\n' "$*"; }
ok()   { printf '  \033[32m✓\033[0m %s\n' "$*"; }
warn() { printf '  \033[33m!\033[0m %s\n' "$*"; }
problems=0

bold "Setting up LilyKeys"

# --- Homebrew (macOS package manager) -------------------------------------------------------
if [ "$(uname)" = "Darwin" ] && ! command -v brew >/dev/null 2>&1; then
  bold "Installing Homebrew. It may ask for your Mac password."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do [ -x "$b" ] && eval "$("$b" shellenv)"; done
fi
have_brew() { command -v brew >/dev/null 2>&1; }
install_pkg() {   # install_pkg <brew name> <apt name>
  if have_brew; then brew install "$1" || brew upgrade "$1"
  elif command -v apt-get >/dev/null 2>&1; then sudo apt-get update && sudo apt-get install -y "$2"
  else return 1; fi
}

# --- Node.js 18 or newer --------------------------------------------------------------------
node_major() { node -p 'process.versions.node.split(".")[0]' 2>/dev/null || echo 0; }
if [ "$(node_major)" -lt 18 ]; then
  bold "Installing Node.js"
  install_pkg node nodejs
fi
if [ "$(node_major)" -ge 18 ]; then ok "Node.js $(node -v)"; else warn "Node.js 18 or newer is needed: https://nodejs.org"; problems=1; fi

# --- LilyPond 2.24 or newer -----------------------------------------------------------------
ly_version() { lilypond --version 2>/dev/null | head -1 | sed -E 's/.*LilyPond ([0-9]+\.[0-9]+).*/\1/'; }
ly_ok() { v=$(ly_version); [ -n "$v" ] && [ "$(printf '%s\n2.24\n' "$v" | sort -V | head -1)" = "2.24" ]; }
if ! ly_ok; then
  bold "Installing LilyPond (music engraving)"
  install_pkg lilypond lilypond
fi
if ly_ok; then ok "LilyPond $(ly_version)"; else warn "LilyPond 2.24 or newer is needed: https://lilypond.org/download.html"; problems=1; fi

# --- Claude Code (composing) ----------------------------------------------------------------
if ! command -v claude >/dev/null 2>&1; then
  bold "Installing Claude Code (Claude composes the music)"
  curl -fsSL https://claude.ai/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
fi
if command -v claude >/dev/null 2>&1; then
  ok "Claude Code $(claude --version 2>/dev/null | awk '{print $1}')"
  if claude auth status 2>/dev/null | grep -q '"loggedIn": *true'; then ok "Claude Code is signed in"
  else
    bold "Claude Code needs you to sign in once."
    echo "  Claude will open now. Sign in, then type /exit to come back here."
    read -r -p "  Press Return to sign in (or type s to skip): " answer
    [ "$answer" != "s" ] && claude
  fi
else
  warn "Claude Code could not be installed. Composing will not work until it is: https://claude.com/claude-code"
  problems=1
fi

# --- Instrument sounds ------------------------------------------------------------------------
if command -v node >/dev/null 2>&1; then
  bold "Downloading orchestra and band sounds (about 150 MB, only the first time)"
  if node server.js --fetch-sounds; then ok "Instrument sounds are ready"
  else warn "Some sounds did not download. LilyKeys will try again when they are needed, and synths stand in until then."; fi
fi

chmod +x start.command setup.command 2>/dev/null
if [ "$problems" = 0 ]; then
  bold "All set. Double-click start.command to open LilyKeys."
else
  bold "Setup finished with problems (see the ! lines above). Fix those, then run setup.command again."
fi
[ -t 0 ] && [ -z "${LILYKEYS_FROM_START:-}" ] && read -r -p "Press Return to close." _
exit $problems
