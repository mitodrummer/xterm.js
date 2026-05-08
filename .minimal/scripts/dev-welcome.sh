#!/usr/bin/env bash
# Banner + tooling cheatsheet shown when a new bash pane opens in the
# Minimal dev sandbox. Sourced from .minimal/scripts/dev-bashrc.sh.
set -euo pipefail

if [ -t 1 ]; then
  b=$'\e[1m'; d=$'\e[2m'; c=$'\e[97m'; y=$'\e[33m'; g=$'\e[32m'; r=$'\e[0m'
else
  b=; d=; c=; y=; g=; r=
fi

# First non-loopback IPv4 the sandbox has (for accessing the demo from
# the host browser). The Minimal sandbox doesn't ship `hostname` or
# `ip`, so parse /proc/net/fib_trie: each `<addr>\n  32 host LOCAL` block
# names a locally-bound /32. Skip 127.x and we're left with the eth0 IP.
sandbox_ip=$(awk '/32 host LOCAL/{print prev} {prev=$2}' /proc/net/fib_trie 2>/dev/null \
  | awk '!/^127\./ && /^[0-9]/' | sort -u | head -n1)
sandbox_ip=${sandbox_ip:-<sandbox-ip>}

cat <<EOF
${c}     █████    █████
     ██████   ██████
     ████████ ████████
█████ ████████ ████████
██████ ████████ ████████
██████   ██████   ██████${r}
${d}minimal · xterm.js dev sandbox${r}

${b}Demo${r} (running at ${g}http://localhost:3000${r} and ${g}http://${sandbox_ip}:3000${r})
  ${y}npm run dev${r}                  Start tsc + esbuild watchers + demo server
  ${y}npm start${r}                    Demo server only (no watchers)
  ${y}npm run watch${r}                tsc -w only

${b}Build${r}
  ${y}npm run build${r}                Compile TypeScript (tsgo)
  ${y}npm run esbuild${r}              Bundle src + addons + headless
  ${y}min run package${r}              Production webpack bundle (lib/)
  ${y}min run clean${r}                Remove build artifacts

${b}Quality${r}
  ${y}min run test${r}                 Unit tests + lint (npm test lifecycle)
  ${y}min run e2e${r}                  Playwright integration (Chromium)
  ${y}min run lint${r}                 ESLint over src + addons + typings
  ${y}npm run lint-fix${r}             Auto-fix lint issues

${b}Zellij${r} (default keybindings)
  ${g}Alt-h/j/k/l${r}     Focus pane in direction
  ${g}Alt-n${r}           New pane (split)
  ${g}Alt-+/-${r}         Resize current pane
  ${g}Ctrl-p z${r}        Toggle pane fullscreen
  ${g}Ctrl-p x${r}        Close current pane
  ${g}Ctrl-s${r}          Scroll/search mode ${d}(Esc to exit)${r}
  ${g}Ctrl-o d${r}        Detach session ${d}(\`zellij a dev\` to reattach)${r}
  ${g}Ctrl-q${r}          Quit zellij

${d}Re-run this banner: ${y}.minimal/scripts/dev-welcome.sh${r}
EOF
