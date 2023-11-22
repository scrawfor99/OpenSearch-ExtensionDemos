#!/bin/bash

source ~/source/dblock/demo-magic/demo-magic.sh

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=30

function comment() {
  cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  echo -en "$cmd"; echo ""
}

clear
pe

comment "# Install the Java Extension into OpenSearch:"
pe "cd ~/source/opensearch-project/opensearch-sdk-java/dblock-opensearch-sdk-java/"
pe "cat bin/main/org/opensearch/sdk/sample/helloworld/hello.json | jq"
pe "curl -s -XPOST \"localhost:9200/_extensions/initialize\" -H \"Content-Type:application/json\" --data @bin/main/org/opensearch/sdk/sample/helloworld/hello.json | jq"

comment "# Query the REST endpoint:"
pe "curl http://localhost:9200/_extensions/_hello-world-java/hello"
