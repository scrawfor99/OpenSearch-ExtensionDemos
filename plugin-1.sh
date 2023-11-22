#!/bin/bash

source ~/source/dblock/demo-magic/demo-magic.sh

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=30

function comment() {
  cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  echo -en "$cmd"; echo ""
}

clear

comment "# Install and run an OpenSearch plugin ..."
pe

comment "# Assemble the Java plugin:"
pe "cd ~/source/opensearch-project/opensearch-hello-plugin-java"
pe "./gradlew assemble"

comment "# This produces a ZIP file:"
pe "find . -name *.zip"

comment "# Install the plugin into OpenSearch:"
pe "cd ~/source/opensearch-project/OpenSearch/dblock-OpenSearch/"
pe "./distribution/archives/darwin-arm64-tar/build/install/opensearch-3.0.0-SNAPSHOT/bin/opensearch-plugin install file:///Users/dblock/source/opensearch-project/opensearch-hello-plugin-java/build/distributions/hello.zip"

comment "# Start OpenSearch:"
pe "./gradlew run"

comment "# Remove plugin:"
pe "./distribution/archives/darwin-arm64-tar/build/install/opensearch-3.0.0-SNAPSHOT/bin/opensearch-plugin remove hello"

