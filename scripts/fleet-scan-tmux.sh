#!/bin/bash
# tmux 舰队扫描：pane_id · session · 窗格标题 · 光标行。覆盖写 $FLEET_SNAPSHOT。
# iTerm2 版仍是 scripts/fleet-scan.sh；本机无 iTerm2 时用这一份。
set -uo pipefail

: "${FLEET_HOME:?缺少环境变量 FLEET_HOME（舰队工作目录）。见 scripts/README-env.md}"
SNAP="${FLEET_SNAPSHOT:-$FLEET_HOME/fleet-snapshot.txt}"
SOCK="${QS_TMUX_SOCKET:-starfix-fleet}"

if ! command -v tmux >/dev/null 2>&1; then
  echo "环境缺 tmux" >&2
  exit 1
fi

{
  echo "# 舰队快照 $(date '+%Y-%m-%d %H:%M:%S') socket=$SOCK"
  echo "# 复制 pane_id，禁止手写前缀猜测"
  tmux -L "$SOCK" list-panes -a -F $'#{pane_id}\t#{session_name}:#{window_index}.#{pane_index}\t#{pane_title}\t#{pane_current_command}\t#{pane_dead}' 2>/dev/null \
    || echo "# tmux -L $SOCK 无会话"
} > "$SNAP"
echo "$SNAP"
