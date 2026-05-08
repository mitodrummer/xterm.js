# shellcheck shell=bash
# shellcheck disable=SC1091  # /etc/bash.bashrc and ~/.bashrc are user-supplied
# Sourced as the bash --rcfile for the zellij shell pane spawned inside the
# Minimal dev sandbox (see .minimal/scripts/setup-dev.sh). Pulls in the
# user's normal rcfiles, then prints the welcome banner once per top-level
# shell.
#
# No `set -euo pipefail` — this is an interactive rcfile and `-e` would
# kill the user's shell on any non-zero command.

[ -r /etc/bash.bashrc ] && source /etc/bash.bashrc
[ -r "$HOME/.bashrc" ] && source "$HOME/.bashrc"

if [ -z "${MINIMAL_WELCOME_SHOWN:-}" ] && [[ $- == *i* ]]; then
  export MINIMAL_WELCOME_SHOWN=1
  "$(dirname "${BASH_SOURCE[0]}")/dev-welcome.sh"
fi
