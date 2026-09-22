# 把一个新业务项目接到现有舰队

**语言 / Language：** [中文](new-project.md)

`demo.sh` 证明闭环。这份说明把**另一个真实目录**接到已经在跑的舰长窗上。规程仓不绑定某一个业务仓。

登记落在 `$FLEET_HOME/projects/`，不进 git。细节：[specs/fleet-projects.md](../specs/fleet-projects.md)。

## 前置

- 已经 `export FLEET_HOME=...` 且 `fleet health` 能跑
- 舰员通道已通（本机最小是 tmux：`start-fleet.sh`）
- 业务目录已经存在（git 仓或协作入口均可）

## 四步

```bash
source "$FLEET_HOME/env.sh"
fleet project add myapp "$HOME/project/myapp"     # 目录里有 .grok/config.toml 时加 --trust
fleet project use myapp
source "$FLEET_HOME/env.sh"
bash "$FLEET_HOME/start-fleet.sh" --respawn
```

然后先派一张**只读摸底**（投递、回执、关键词、cwd 对不对），再派业务。

## 项目骨架里要写清的

打开 `$FLEET_HOME/projects/myapp/任务书.md`，改这几行，以后每单从这里抄红线：

- 规程文件在哪（本机 `AGENTS.md` 还是远程 MCP 规则）
- 可写范围怎么写（本机路径，还是远程 worktree）
- 验证命令是本机脚本还是 MCP 工具
- 并线/部署是本机 git，还是该项目自己的发布门

## 不要做的

- 不要把项目 MCP 写进 `~/.grok/config.toml`
- 不要把密钥写进项目目录或回执
- 不要以为 `fleet project use` 会改当前已经开着的舰长进程环境——本窗要再 `source env.sh`
- 切换项目不会清空激活器；旧单的 worktree 可能过期，盘点时归档或改 note
