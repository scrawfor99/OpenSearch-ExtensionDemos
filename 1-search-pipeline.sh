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

comment "# Add a new search processor and use search pipelines in OpenSearch ($ROOT)..."
comment "# "

# Define the variables
pe 'OPENSEARCH_DIR="./OpenSearch"' # Replace with your OpenSearch directory
pe 'cd $OPENSEARCH_DIR'

# apply patch 
git apply ../1-search-pipeline-1.patch

pe './gradlew localDistro' 

# Create a command to run Gradle
GRADLE_COMMAND="./gradlew run"

wait
# Use AppleScript to open a new Terminal window and run the command
p 'osascript -e \"tell application \"Terminal\" to do script \"cd $OPENSEARCH_DIR; $GRADLE_COMMAND\"\"'
osascript -e "tell application \"Terminal\" to do script \"cd $OPENSEARCH_DIR; $GRADLE_COMMAND\""

wait
# Step 8: Check if the cluster is running
pe "curl http://localhost:9200"

wait
# Step 9: Index a document
p "curl -XPUT http://localhost:9200/test_index/_doc/1 -H 'Content-Type: application/json' -d '{"customer": {"name": "John"}, "pii": {"ssn":"123456"}}'"
curl -XPUT http://localhost:9200/test_index/_doc/1 -H 'Content-Type: application/json' -d '{"customer": {"name": "John"}, "pii": {"ssn":"123456"}}'

wait
# Step 10: Create a new search pipeline
p "curl -XPUT "http://localhost:9200/_search/pipeline/my_pipeline" -H 'Content-Type: application/json' -d '{"response_processors": [{"rename_field": {"field": "pii","target_field": "hash"}}]}'"
curl -XPUT "http://localhost:9200/_search/pipeline/my_pipeline" -H 'Content-Type: application/json' -d '{"response_processors": [{"rename_field": {"field": "pii","target_field": "hash"}}]}'

wait
# Step 11: Create a second search pipeline
p "curl -XPUT "http://localhost:9200/_search/pipeline/my_pipeline2" -H 'Content-Type: application/json' -d '{"response_processors": [{"delete_field": {"field": "pii"}}]}'"
curl -XPUT "http://localhost:9200/_search/pipeline/my_pipeline2" -H 'Content-Type: application/json' -d '{"response_processors": [{"delete_field": {"field": "pii"}}]}'

wait
# Step 12: Demo with the first pipeline
p "curl -XGET "http://localhost:9200/test_index/_search?search_pipeline=my_pipeline""
curl -XGET "http://localhost:9200/test_index/_search?search_pipeline=my_pipeline"

wait
# Step 13: Demo with the second pipeline
p "curl -XGET "http://localhost:9200/test_index/_search?search_pipeline=my_pipeline2""
curl -XGET "http://localhost:9200/test_index/_search?search_pipeline=my_pipeline2"
p ""

#clean up 
git apply -R ../1-search-pipeline-1.patch
./gradlew clean 
