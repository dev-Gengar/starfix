#!/usr/bin/env bash
# 复制到 $FLEET_HOME/env.sh 后按本机改 STARFIX_ROOT / FLEET_HOME。
# 不要把填好真实路径的副本提交进规程仓。

export FLEET_HOME="${HOME}/fleet-data"
export STARFIX_ROOT="${HOME}/project/starfix"
export QS_TMUX_SOCKET="starfix-fleet"
export FLEET_RECEIPT_DIR="${FLEET_HOME}/回执"
export FLEET_SCRIPTS_DIR="${STARFIX_ROOT}/scripts"
export FLEET_ASK_PANEL="${FLEET_HOME}/请示台.md"
export FLEET_ASK_INBOX="${FLEET_HOME}/ask-inbox.jsonl"
export SECRETS_DIR="${HOME}/.secrets"
export QS_SEND="${STARFIX_ROOT}/quickstart/send-to-tmux.sh"

export PATH="${FLEET_HOME}/bin:${STARFIX_ROOT}/scripts:${HOME}/.local/bin:${HOME}/.grok/bin:${PATH}"

if [ -f "${FLEET_HOME}/projects/current" ]; then
  FLEET_PROJECT="$(tr -d '[:space:]' < "${FLEET_HOME}/projects/current")"
  export FLEET_PROJECT
  if [ -n "${FLEET_PROJECT}" ] && [ -f "${FLEET_HOME}/projects/${FLEET_PROJECT}/env.sh" ]; then
    # shellcheck disable=SC1090
    . "${FLEET_HOME}/projects/${FLEET_PROJECT}/env.sh"
  fi
fi
