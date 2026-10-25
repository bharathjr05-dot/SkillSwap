#!/bin/sh
set -eu

PORT="${PORT:-8080}"
SERVER_XML="$CATALINA_HOME/conf/server.xml"

sed -i 's/<Server port="[0-9][0-9]*" shutdown=/<Server port="-1" shutdown=/' "$SERVER_XML"
sed -i "s/<Connector port=\"8080\"/<Connector port=\"${PORT}\"/" "$SERVER_XML"

exec "$CATALINA_HOME/bin/catalina.sh" run
