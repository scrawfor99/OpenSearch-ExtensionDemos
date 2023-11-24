#!/bin/bash

ROOT=$(readlink -f ${0%/*})

source "$ROOT/demo-magic/demo-magic.sh"

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=50

function comment() {
  cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  echo -en "$cmd"; echo ""
}

clear

comment "# Add a new search processor and use search pipelines in OpenSearch ($ROOT)..."
comment "# "

# apply patch 
cd ./OpenSearch
git apply ../1-search-pipeline-1.patch

# build
pe './gradlew localDistro' 

comment "Start OpenSearch"
osascript -e "tell application \"Terminal\" to do script \"cd $ROOT/OpenSearch; ./gradlew run\""

# Step 8: Check if the cluster is running
comment "Here's the OpenSearch we're running"
pe "curl -s http://localhost:9200 | jq"

# Step 9: Index a document
comment "Index a document"
pe "curl -s -XPUT http://localhost:9200/test_index/_doc/1 -H 'Content-Type: application/json' -d '{\"customer\": {\"name\": \"John\"}, \"pii\": {\"ssn\":\"123456\"}}' | jq"

# Step 10: Create a new search pipeline
comment "Create a new search pipeline that renames the PII field"
pe "curl -s -XPUT "http://localhost:9200/_search/pipeline/rename_field_pipeline" -H 'Content-Type: application/json' -d '{\"response_processors\": [{\"rename_field\": {\"field\": \"pii\",\"target_field\": \"secret\"}}]}' | jq"

# Step 11: Create a second search pipeline
comment "Create a second search pipeline that deletes PII"
pe "curl -s -XPUT "http://localhost:9200/_search/pipeline/remove_field_pipeline" -H 'Content-Type: application/json' -d '{\"response_processors\": [{\"delete_field\": {\"field\": \"pii\"}}]}' | jq"

# Step 12: Demo with the first pipeline
comment "Search using the rename pipeline"
pe "curl -s -XGET "http://localhost:9200/test_index/_search?search_pipeline=rename_field_pipeline" | jq"

# Step 13: Demo with the second pipeline
comment "Search using the remove pipeline"
pe "curl -s -XGET "http://localhost:9200/test_index/_search?search_pipeline=remove_field_pipeline" | jq"

# clean up 
comment "Cleanup, manually close the OpenSearch window ..."
git apply -R ../1-search-pipeline-1.patch
cd ..
