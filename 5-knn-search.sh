#!/bin/bash
ROOT=$(readlink -f ${0%/*})
cd "$ROOT"
source "$ROOT/demo-magic/demo-magic.sh"

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=30

function comment() {
  cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  echo -en "$cmd"; echo ""
}

clear

comment "In this demo: index and search some documents with k-nn plugin."

comment "Build and install OpenSearch k-nn plugin"
pe "cd k-NN"
pe "./gradlew assemble"

comment "This produces a ZIP file:"
pe "find . -name opensearch-*.zip"

comment "Install the plugin into OpenSearch:"
pe "cd ../OpenSearch"
pe "./distribution/archives/darwin-arm64-tar/build/install/opensearch-3.0.0-SNAPSHOT/bin/opensearch-plugin install file:///$ROOT/k-NN/build/distributions/opensearch-knn-3.0.0.0-SNAPSHOT.zip"

comment "Start OpenSearch:"
pe
osascript -e "tell application \"Terminal\" to do script \"cd $ROOT/OpenSearch; ./gradlew run\""

comment "Here's the OpenSearch we're running:"
pe "curl http://localhost:9200 | jq"

comment "Create an index:"
pe "cat \"$ROOT/5-knn-search-mapping.json\" | jq"
pe "curl -X PUT http://localhost:9200/knn-index/ -H \"Content-Type: application/json\" --data @\"$ROOT/5-knn-search-mapping.json\" | jq"

comment "Index a couple of documents:"
pe "curl -X PUT http://localhost:9200/knn-index/_doc/1 -H \"Content-Type: application/json\" --data '{\"values\":[0.1, 0.2, 0.3]}' | jq"
pe "curl -X PUT http://localhost:9200/knn-index/_doc/2 -H \"Content-Type: application/json\" --data '{\"values\":[0.2, 0.3, 0.4]}' | jq"

comment "Search:"
pe "curl -X POST http://localhost:9200/knn-index/_search -H \"Content-Type: application/json\" --data '{\"query\": {\"knn\": {\"values\": {\"vector\": [0.7, 0.25, 0.4], \"k\": 1}}}}' | jq"

comment "Delete the index:"
pe "curl -X DELETE http://localhost:9200/knn-index | jq"

comment "Cleanup, remove plugin, manually close the OpenSearch  window ..."
pe "./distribution/archives/darwin-arm64-tar/build/install/opensearch-3.0.0-SNAPSHOT/bin/opensearch-plugin remove opensearch-knn"
cd ..
