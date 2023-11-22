#!/bin/bash
ROOT=$(readlink -f ${0%/*})

source "$ROOT/demo-magic/demo-magic.sh"

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=30

function comment() {
  cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  echo -en "$cmd"; echo ""
}

clear

comment "# Install and run an OpenSearch plugin ($ROOT)..."
comment "# Assemble the Java plugin:"
pe "cd opensearch-hello-plugin-java"
pe "./gradlew assemble"

comment "# This produces a ZIP file:"
pe "find . -name *.zip"

comment "# Build OpenSearch:"
pe "cd ../OpenSearch"
comment "# Install the plugin into OpenSearch:"
pe "./distribution/archives/darwin-arm64-tar/build/install/opensearch-3.0.0-SNAPSHOT/bin/opensearch-plugin install file:///$ROOT/opensearch-hello-plugin-java/build/distributions/hello.zip"

comment "# Start OpenSearch:"
pe "./gradlew run"

comment "# Remove plugin:"
pe "./distribution/archives/darwin-arm64-tar/build/install/opensearch-3.0.0-SNAPSHOT/bin/opensearch-plugin remove hello"


