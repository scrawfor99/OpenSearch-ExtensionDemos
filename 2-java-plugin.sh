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

comment "In this demo: install and query a Java plugin."
comment "Install and run an OpenSearch plugin ..."
comment "Assemble the Java plugin:"
pe "cd opensearch-hello-plugin-java"
pe "./gradlew assemble"

comment "This produces a ZIP file:"
pe "find . -name *.zip"

comment "Install the plugin into OpenSearch:"
pe "cd ../OpenSearch"
pe "./distribution/archives/darwin-arm64-tar/build/install/opensearch-3.0.0-SNAPSHOT/bin/opensearch-plugin install file:///$ROOT/opensearch-hello-plugin-java/build/distributions/hello.zip"

comment "Start OpenSearch:"
osascript -e "tell application \"Terminal\" to do script \"cd $ROOT/OpenSearch; ./gradlew run\""

comment "Here's the OpenSearch we're running:"
pe "curl http://localhost:9200 | jq"

comment "Call the REST endpoint:"
pe "curl http://localhost:9200/_plugins/hello-world-java"

comment "Cleanup, remove plugin, manually close the OpenSearch and Extension windows ..."
pe "./distribution/archives/darwin-arm64-tar/build/install/opensearch-3.0.0-SNAPSHOT/bin/opensearch-plugin remove hello"
cd ..
