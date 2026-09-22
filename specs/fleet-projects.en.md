# Fleet multi-project

**语言 / Language:** [中文](fleet-projects.md) · [English](fleet-projects.en.md)

The StarFix rules repo holds generic law only. Each product project's cwd, task-book red lines, and Grok flags live under `$FLEET_HOME/projects/<id>/`, not in this repo.

## Layout

```
$FLEET_HOME/projects/current          # active project id, one line
$FLEET_HOME/projects/<id>/env.sh      # FLEET_CREW_CWD / template / grok flags
$FLEET_HOME/projects/<id>/任务书.md   # optional project task-book skeleton
```

## Commands

```
fleet project list
fleet project show
fleet project add <id> <cwd> [--trust] [--template <path>]
fleet project use <id>
```

`env.sh` sources `projects/<current>/env.sh` after setting `FLEET_HOME`. With no project registered, crew cwd is unset and `fleet health` prints INFO.

## Minimum steps for a new project

1. Have a product directory (git repo or collaboration stub).
2. `fleet project add myapp "$HOME/project/myapp"`. Add `--trust` if that directory has `.grok/config.toml` (project MCP).
3. Write red lines into `projects/myapp/任务书.md`.
4. `fleet project use myapp`
5. `bash "$FLEET_HOME/start-fleet.sh" --respawn`
6. Dispatch a tiny read-only probe before business work.

## Red lines

- Project MCP stays in that project's `.grok/config.toml`. Do not copy it into `~/.grok/config.toml`.
- Secrets stay in `SECRETS_DIR`.
- Merge/deploy follow that project's task book. §7 is the default playbook; a project skeleton may narrow it.
- Switching projects does not reset the activator ledger; old worktree paths may be stale.
