#!/usr/bin/env bash
# 起 / 复用 tmux 舰队会话。pane_id 只从 list-panes / fleet-snapshot 复制。
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
STARFIX_ROOT="${STARFIX_ROOT:-$(cd "${HERE}/.." && pwd)}"

if [ -z "${FLEET_HOME:-}" ]; then
  echo "缺少 FLEET_HOME" >&2
  exit 2
fi
# shellcheck disable=SC1091
. "${FLEET_HOME}/env.sh"
export STARFIX_ROOT="${STARFIX_ROOT:-$(cd "${HERE}/.." && pwd)}"

SOCK="${QS_TMUX_SOCKET:-starfix-fleet}"
SESSION="fleet"
TMUX=(tmux -L "$SOCK")
GROK="$(command -v grok || true)"
[ -n "$GROK" ] || GROK="${HOME}/.grok/bin/grok"
CWD="${FLEET_CREW_CWD:-}"
if [ -z "$CWD" ] || [ ! -d "$CWD" ]; then
  echo "没有当前项目 cwd。先：fleet project add <id> <目录> && fleet project use <id>" >&2
  exit 2
fi
GROK_ARGS="${FLEET_GROK_ARGS:-}"

if ! command -v tmux >/dev/null 2>&1; then
  echo "环境缺 tmux" >&2
  exit 1
fi
if [ ! -x "$GROK" ]; then
  echo "找不到 grok：$GROK" >&2
  exit 1
fi

mkdir -p "$FLEET_HOME/回执" "$FLEET_HOME/crew" "$FLEET_HOME/inbox" "$FLEET_HOME/handoff"

CREW_CMD="PATH=${HOME}/.local/bin:${HOME}/.grok/bin:${PATH} FLEET_HOME=${FLEET_HOME} QS_TMUX_SOCKET=${SOCK} TERM=xterm-256color exec ${GROK} ${GROK_ARGS} --cwd ${CWD}"

respawn_crew() {
  "${TMUX[@]}" set-option -t "$SESSION" allow-rename off
  "${TMUX[@]}" set-window-option -t "$SESSION" automatic-rename off
  "${TMUX[@]}" select-pane -t "${SESSION}:0.0" -T '舰员甲-承建'
  "${TMUX[@]}" respawn-pane -k -t "${SESSION}:0.0" "$CREW_CMD"
  "${TMUX[@]}" select-pane -t "${SESSION}:0.1" -T '舰员乙-复审'
  "${TMUX[@]}" respawn-pane -k -t "${SESSION}:0.1" "$CREW_CMD"
  echo "已把甲/乙切到 ${CWD}（项目 ${FLEET_PROJECT:-?}  grok ${GROK_ARGS:-无额外参数}）"
  "${TMUX[@]}" list-panes -t "$SESSION" -F $'#{pane_id}\t#{session_name}:#{window_index}.#{pane_index}\t#{pane_title}\t#{pane_current_command}\t#{pane_width}x#{pane_height}'
}

if "${TMUX[@]}" has-session -t "$SESSION" 2>/dev/null; then
  if [ "${1:-}" = "--respawn" ]; then
    respawn_crew
    exit 0
  fi
  echo "已有会话 ${SESSION}（socket ${SOCK}），不重建。切工位：fleet start --respawn"
  "${TMUX[@]}" list-panes -t "$SESSION" -a -F $'#{pane_id}\t#{session_name}:#{window_index}.#{pane_index}\t#{pane_title}\t#{pane_current_command}\t#{pane_width}x#{pane_height}'
  exit 0
fi

TERM=xterm-256color "${TMUX[@]}" new-session -d -s "$SESSION" -n crew -x 220 -y 50
"${TMUX[@]}" set-option -t "$SESSION" default-terminal "screen-256color"
"${TMUX[@]}" set-option -t "$SESSION" mouse on
"${TMUX[@]}" set-option -t "$SESSION" status on
"${TMUX[@]}" set-option -t "$SESSION" allow-rename off
"${TMUX[@]}" set-window-option -t "$SESSION" automatic-rename off
"${TMUX[@]}" set-option -t "$SESSION" pane-border-status top
"${TMUX[@]}" set-option -t "$SESSION" pane-border-format '#{pane_id} #{pane_title}'
"${TMUX[@]}" select-pane -t "${SESSION}:0.0" -T '舰员甲-承建'
"${TMUX[@]}" respawn-pane -k -t "${SESSION}:0.0" "$CREW_CMD"
"${TMUX[@]}" split-window -h -t "${SESSION}:0"
"${TMUX[@]}" select-pane -t "${SESSION}:0.1" -T '舰员乙-复审'
"${TMUX[@]}" respawn-pane -k -t "${SESSION}:0.1" "$CREW_CMD"
"${TMUX[@]}" select-layout -t "${SESSION}:0" even-horizontal

echo "已起会话 ${SESSION}（socket ${SOCK}）"
"${TMUX[@]}" list-panes -t "$SESSION" -F $'#{pane_id}\t#{session_name}:#{window_index}.#{pane_index}\t#{pane_title}\t#{pane_current_command}\t#{pane_width}x#{pane_height}'
