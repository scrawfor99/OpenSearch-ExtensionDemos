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

comment "# Enable extensions in OpenSearch"
pe "cd ~/source/opensearch-project/OpenSearch/dblock-OpenSearch/"
pe "git diff"

comment "# Build and run a Java Extension"
pe "cd ~/source/opensearch-project/opensearch-sdk-java/dblock-opensearch-sdk-java/"
pe "./gradlew helloWorld"
