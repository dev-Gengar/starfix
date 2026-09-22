#!/usr/bin/env bash
# 不碰本机 FLEET_HOME。在临时目录里走一遍 add / use / list。
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
STARFIX_ROOT="$(cd "${HERE}/.." && pwd)"
TMP="$(mktemp -d "${TMPDIR:-/tmp}/starfix-fleet-project.XXXXXX")"
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

export FLEET_HOME="$TMP/fleet"
export STARFIX_ROOT
mkdir -p "$FLEET_HOME" "$TMP/app"
cat > "$FLEET_HOME/env.sh" <<EOF
export FLEET_HOME="$FLEET_HOME"
export STARFIX_ROOT="$STARFIX_ROOT"
export PATH="$STARFIX_ROOT/scripts:\$PATH"
if [ -f "\$FLEET_HOME/projects/current" ]; then
  FLEET_PROJECT="\$(tr -d '[:space:]' < "\$FLEET_HOME/projects/current")"
  export FLEET_PROJECT
  if [ -n "\$FLEET_PROJECT" ] && [ -f "\$FLEET_HOME/projects/\$FLEET_PROJECT/env.sh" ]; then
    . "\$FLEET_HOME/projects/\$FLEET_PROJECT/env.sh"
  fi
fi
EOF

# shellcheck disable=SC1091
. "$FLEET_HOME/env.sh"
bash "$STARFIX_ROOT/scripts/fleet-project.sh" add app "$TMP/app"
bash "$STARFIX_ROOT/scripts/fleet-project.sh" use app
# shellcheck disable=SC1091
. "$FLEET_HOME/env.sh"
[ "$FLEET_PROJECT" = "app" ]
[ "$FLEET_CREW_CWD" = "$TMP/app" ]
out="$(bash "$STARFIX_ROOT/scripts/fleet-project.sh" list)"
printf '%s\n' "$out" | grep -q 'app'
echo "PASS fleet-project add/use/list TMP=$TMP"
