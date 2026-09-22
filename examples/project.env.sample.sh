# 样例：复制到 $FLEET_HOME/projects/<id>/env.sh
# 不要把这个文件改成真实路径后提交进规程仓。

export FLEET_PROJECT="myapp"
export FLEET_CREW_CWD="$HOME/project/myapp"
export FLEET_PROJECT_TEMPLATE="$FLEET_HOME/projects/myapp/任务书.md"
# 该目录有项目级 .grok/config.toml（MCP）时才需要：
export FLEET_GROK_ARGS="--trust"
