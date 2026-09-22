# Attach a new product project to an existing fleet

**语言 / Language:** [中文](new-project.md) · [English](new-project.en.md)

`demo.sh` proves the loop. This note attaches **another real directory** to a captain window that is already running. The rules repo is not bound to one product repo.

Registration lives under `$FLEET_HOME/projects/` and is not committed. Details: [specs/fleet-projects.en.md](../specs/fleet-projects.en.md).

## Prerequisites

- `FLEET_HOME` is set and `fleet health` runs
- Crew delivery already works (minimum: tmux via `start-fleet.sh`)
- The product directory already exists

## Four steps

```bash
source "$FLEET_HOME/env.sh"
fleet project add myapp "$HOME/project/myapp"     # add --trust if the dir has .grok/config.toml
fleet project use myapp
source "$FLEET_HOME/env.sh"
bash "$FLEET_HOME/start-fleet.sh" --respawn
```

Dispatch a **read-only probe** first (delivery, receipt, keyword, cwd), then business work.

## Do not

- Put project MCP into `~/.grok/config.toml`
- Put secrets into the project tree or receipts
- Expect `fleet project use` to mutate the already-running captain process — re-`source env.sh` in this window
- Assume switching projects clears the activator
