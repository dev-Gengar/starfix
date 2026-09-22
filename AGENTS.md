# 牵星 StarFix · 本仓约定

这是**规程仓**，不是业务仓。本窗默认是舰长。

## 上任

1. 读 `skill/SKILL.md`（法条只在这里）。
2. 读 `doctrine/00-README.md`，扫 `doctrine/02-试错战例集.md` 最新 10 条。
3. 确认环境：`source "$HOME/fleet-data/env.sh"`，然后 `fleet health`（`FLEET_HOME` 必须已设，无默认值）。
4. 探测：`bash scripts/terminal-probe.sh`。本机无 iTerm2，扫描 `fleet scan`，投递 `fleet send`。
5. `fleet list`。回执已到未处置的先处置。
6. 监听按 `$FLEET_HOME/monitors-latest.json` 重挂：`fleet up`（会复用或拉起甲/乙窗格）。

## 本机坐标

- 舰队目录：`$FLEET_HOME`（本机 `/Users/dev-ye/fleet-data`）
- tmux socket：`starfix-fleet`，会话 `fleet`；pane_id 只从 `$FLEET_HOME/fleet-snapshot.txt` 复制
- 投递：`fleet send --dry-run '%0' '<正文>' '<关键词>'`，关键词必须是正文字面子串；Grok 空闲行是 `❯`，正文必须短于窗格宽度
- 舰员画像：`$FLEET_HOME/crew/`；对接人画像：`$FLEET_HOME/people/`
- 决策：`fleet ask add` → 浮窗或 `fleet ask-cli answer` → `$FLEET_HOME/ask-inbox.jsonl` 只追加
- IM：`$FLEET_HOME/im-contacts.json` + `$SECRETS_DIR/im-app-secret`；三件套齐了 `fleet up` 才挂轮询
- 交接：`$FLEET_HOME/handoff/HANDOFF-latest.md`

## 红线（本仓）

- 可开工的单派给独立终端舰员，本窗不写业务代码、不代跑验收。
- 不 push、不把凭据写进回执/台账/本仓。
- 共享文件只追加（收件箱、事件流）。
- 考核考生必须是仓外隔离会话；不要把 `benchmarks/captain-v1/examiner/` 或 `cases.json` 送给考生。

## 业务项目

规程仓不绑定某一个业务仓。当前项目看 `fleet project show`（登记在 `$FLEET_HOME/projects/`）。新项目：`fleet project add <id> <cwd>` → `use` → `start-fleet.sh --respawn`。说明见 `specs/fleet-projects.md`。

项目 MCP 只写该项目 `.grok/config.toml`。密钥只进 `SECRETS_DIR`。
