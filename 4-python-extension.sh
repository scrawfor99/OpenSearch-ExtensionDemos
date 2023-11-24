#!/bin/bash
ROOT=$(readlink -f ${0%/*})
cd "$ROOT"
source "$ROOT/demo-magic/demo-magic.sh"

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=50

function comment() {
  cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  echo -en "$cmd"; echo ""
}

clear

comment "In this demo: enable extensions, install and run an extension, query it."
comment "First, enable extensions by modifying gradle/run.gradle, it's an experimental feature."
pe "cd OpenSearch"
git apply ../4-python-extension-1.patch
pe "git diff"
comment "Start OpenSearch"
pe
osascript -e "tell application \"Terminal\" to do script \"cd $ROOT/OpenSearch; ./gradlew run\""
cd ..

comment "Start the Python Extension"
pe "cd opensearch-sdk-py"
pe "cat samples/hello/hello.json | jq"
pe
osascript -e "tell application \"Terminal\" to do script \"cd $ROOT/opensearch-sdk-py; poetry run samples/hello/hello.py\""

comment "Here's the OpenSearch we're running:"
pe "curl http://localhost:9200 | jq"

comment "Install the Python Extension into OpenSearch:"
pe "curl -s -XPOST \"localhost:9200/_extensions/initialize\" -H \"Content-Type:application/json\" --data @samples/hello/hello.json | jq"
cd ..

comment "Query the REST endpoint:"
pe "curl http://localhost:9200/_extensions/_hello-world-py/hello"

comment "Cleanup, close the OpenSearch and Extension windows ..."
cd OpenSearch
git checkout gradle/run.gradle
