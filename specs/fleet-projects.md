# 舰队多项目

**语言 / Language：** [中文](fleet-projects.md)

StarFix 规程仓只放通用法条。每个业务项目的 cwd、任务书红线、Grok 参数，登记在 `$FLEET_HOME/projects/<id>/`，不写进本仓。

## 目录

```
$FLEET_HOME/projects/current          # 当前项目 id，一行
$FLEET_HOME/projects/<id>/env.sh      # 该项目的 FLEET_CREW_CWD / 模板 / grok 参数
$FLEET_HOME/projects/<id>/任务书.md   # 可选：该项目任务书骨架（红线、写面）
```

## 命令

```
fleet project list
fleet project show
fleet project add <id> <cwd> [--trust] [--template <path>]
fleet project use <id>          # 写 current，随后 start-fleet --respawn
```

`env.sh` 在设完 `FLEET_HOME` 后 source `projects/<current>/env.sh`。没登记项目时舰员 cwd 缺省，health 报 INFO，不假装有业务仓。

## 新项目最小步骤

1. 业务目录就位（git 仓或协作入口均可）。
2. `fleet project add myapp "$HOME/project/myapp"`。若该目录有 `.grok/config.toml`（项目 MCP），加 `--trust`。
3. 把项目红线写进 `projects/myapp/任务书.md`（可写范围、禁令、验证命令怎么写）。
4. `fleet project use myapp`
5. `bash "$FLEET_HOME/start-fleet.sh" --respawn`
6. 先派一张只读摸底单，再派业务。

## 红线

- 项目 MCP 只写该项目 `.grok/config.toml`，禁止拷进 `~/.grok/config.toml`。
- 密钥仍只进 `SECRETS_DIR`。
- 并线/部署以该项目任务书为准：有的项目是本机 git merge，有的必须走远程 Release MCP。规程 §7 是默认剧本，项目骨架可以收窄或改停点。
- 切换项目不重置激活器台账；旧单的 worktree 路径可能过期，盘点时按当前项目处置或归档。
