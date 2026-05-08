#!/usr/bin/env bash
set -euo pipefail

# Launches the dev sandbox: installs deps, then opens a zellij layout with
# Claude on the left and an interactive shell on the right. Watchers and
# the demo server (`npm run dev`) are kicked off from the shell pane —
# see the welcome banner.
#
# Refuses to run on the host: `claude --dangerously-skip-permissions`
# below is only safe inside the ephemeral Minimal sandbox.
if [ "${IS_SANDBOX:-}" != "1" ]; then
  echo ".minimal/scripts/setup-dev.sh must be run inside the Minimal sandbox (IS_SANDBOX=1)." >&2
  echo "Use 'minimal run dev' instead." >&2
  exit 1
fi

npm install

# Bash rcfile that prints the welcome banner. Exported so the shell pane
# inherits it.
export MINIMAL_BASHRC="$PWD/.minimal/scripts/dev-bashrc.sh"

# Kill any prior `dev` session so each run starts from a clean layout.
zellij delete-session --force dev 2>/dev/null || true

# Two-pane layout: Claude on the left (focused), shell on the right. The
# layout is generated at runtime so $MINIMAL_BASHRC expands to an
# absolute path.
layout_file="$(mktemp --suffix=.kdl)"
trap 'rm -f "$layout_file"' EXIT
cat > "$layout_file" <<EOF
layout {
    pane split_direction="vertical" {
        pane focus=true name="claude" command="claude" {
            args "--dangerously-skip-permissions"
        }
        pane name="shell" command="bash" {
            args "--rcfile" "$MINIMAL_BASHRC" "-i"
        }
    }
}
EOF

# No `exec`: keep the parent shell alive so the EXIT trap removes the
# temp layout file after zellij exits.
zellij --layout "$layout_file" attach --create dev
