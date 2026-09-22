#!/usr/bin/env bash
# 便携自证。机器特有检查（launchd / 浮窗）放 $FLEET_HOME/bin/fleet-health.sh，由 scripts/fleet 优先调用。
set -u
HERE="$(cd "$(dirname "$0")" && pwd)"
STARFIX_ROOT="${STARFIX_ROOT:-$(cd "${HERE}/.." && pwd)}"
fail=0
say() { printf '%s\n' "$*"; }
ok() { say "OK  $*"; }
bad() { say "FAIL $*"; fail=1; }

[ -n "${FLEET_HOME:-}" ] && [ -d "$FLEET_HOME" ] && ok "FLEET_HOME=$FLEET_HOME" || bad "FLEET_HOME 未设或目录不存在"
[ -x "${STARFIX_ROOT}/scripts/task-activator.py" ] && ok "activator 脚本在" || bad "找不到 task-activator.py"
if command -v tmux >/dev/null; then ok "tmux=$(command -v tmux) $(tmux -V)"; else bad "PATH 里没有 tmux"; fi
if [ -n "${FLEET_PROJECT:-}" ]; then
  ok "当前项目 $FLEET_PROJECT cwd=${FLEET_CREW_CWD:-?}"
else
  say "INFO 未选业务项目。fleet project add <id> <cwd> && fleet project use <id>"
fi
if [ -n "${QS_TMUX_SOCKET:-}" ] && tmux -L "${QS_TMUX_SOCKET}" has-session -t fleet 2>/dev/null; then
  ok "tmux 会话 fleet（socket ${QS_TMUX_SOCKET}）"
else
  say "INFO 还没有 tmux 会话 fleet。fleet start"
fi
exit "$fail"
