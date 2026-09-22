#!/usr/bin/env bash
# 登记 / 切换业务项目。不改远程、不写全局 MCP。
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
STARFIX_ROOT="${STARFIX_ROOT:-$(cd "${HERE}/.." && pwd)}"
export STARFIX_ROOT

if [ -z "${FLEET_HOME:-}" ]; then
  echo "缺少 FLEET_HOME" >&2
  exit 2
fi
# shellcheck disable=SC1091
. "${FLEET_HOME}/env.sh"
export STARFIX_ROOT="${STARFIX_ROOT:-$(cd "${HERE}/.." && pwd)}"

PROJ_ROOT="${FLEET_HOME}/projects"
mkdir -p "$PROJ_ROOT"

usage() {
  echo "用法：fleet project list|show|add <id> <cwd> [--trust] [--template <path>]|use <id>" >&2
  exit 2
}

current_id() {
  if [ -f "${PROJ_ROOT}/current" ]; then
    tr -d '[:space:]' < "${PROJ_ROOT}/current"
  fi
}

generic_template() {
  if [ -f "${STARFIX_ROOT}/templates/任务书-project.md" ]; then
    echo "${STARFIX_ROOT}/templates/任务书-project.md"
  elif [ -f "${FLEET_HOME}/templates/任务书.md" ]; then
    echo "${FLEET_HOME}/templates/任务书.md"
  else
    echo "${STARFIX_ROOT}/templates/01-任务书.md"
  fi
}

write_env() {
  local id="$1" cwd="$2" trust="${3:-}" template="${4:-}"
  local dir="${PROJ_ROOT}/${id}"
  mkdir -p "$dir"
  local grok_args=""
  [ "$trust" = "1" ] && grok_args="--trust"
  if [ -z "$template" ]; then
    template="${dir}/任务书.md"
    if [ ! -f "$template" ]; then
      cp "$(generic_template)" "$template"
    fi
  fi
  cat > "${dir}/env.sh" <<EOF
# 项目 ${id} —— 由 fleet project add/use 维护
export FLEET_PROJECT="${id}"
export FLEET_CREW_CWD="${cwd}"
export FLEET_PROJECT_TEMPLATE="${template}"
export FLEET_GROK_ARGS="${grok_args}"
EOF
}

cmd="${1:-}"
shift || true
case "$cmd" in
  list)
    cur="$(current_id)"
    echo "当前：${cur:-（未选）}"
    shopt -s nullglob
    for d in "${PROJ_ROOT}"/*/env.sh; do
      id="$(basename "$(dirname "$d")")"
      mark=" "
      [ "$id" = "$cur" ] && mark="*"
      # shellcheck disable=SC1090
      cwd="$(. "$d" >/dev/null; printf '%s' "${FLEET_CREW_CWD:-}")"
      echo "${mark} ${id}  cwd=${cwd}"
    done
    ;;
  show)
    cur="$(current_id)"
    [ -n "$cur" ] || { echo "还没选项目。fleet project add … 然后 fleet project use <id>" >&2; exit 1; }
    echo "id=$cur"
    cat "${PROJ_ROOT}/${cur}/env.sh"
    ;;
  add)
    [ "${#}" -ge 2 ] || usage
    id="$1"
    cwd="$2"
    shift 2
    trust=0
    template=""
    while [ "${#}" -gt 0 ]; do
      case "$1" in
        --trust) trust=1 ;;
        --template) template="$2"; shift ;;
        *) echo "不认识的参数：$1" >&2; usage ;;
      esac
      shift
    done
    case "$id" in
      *[!a-zA-Z0-9._-]*) echo "id 只许字母数字 . _ -" >&2; exit 2 ;;
    esac
    [ -d "$cwd" ] || { echo "cwd 不是目录：$cwd" >&2; exit 2; }
    cwd="$(cd "$cwd" && pwd)"
    if [ -f "${cwd}/.grok/config.toml" ] && [ "$trust" = 0 ]; then
      echo "INFO 该目录有 .grok/config.toml（项目 MCP）。建议加 --trust，否则 Grok 可能不起项目服务器。"
    fi
    write_env "$id" "$cwd" "$trust" "$template"
    echo "已登记 $id → $cwd"
    echo "选用：fleet project use $id"
    echo "然后：fleet start --respawn"
    ;;
  use)
    [ "${#}" -ge 1 ] || usage
    id="$1"
    [ -f "${PROJ_ROOT}/${id}/env.sh" ] || { echo "没有项目 $id。先 fleet project add" >&2; exit 1; }
    printf '%s\n' "$id" > "${PROJ_ROOT}/current"
    echo "当前项目 → $id"
    echo "新开的舰长窗会带上。本窗请：source \"\$FLEET_HOME/env.sh\""
    echo "切舰员工位：fleet start --respawn"
    ;;
  *)
    usage
    ;;
esac
