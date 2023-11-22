#!/bin/bash

. ./demo-magic.sh -n

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=30

# Define the variables
pe 'OPENSEARCH_DIR="./OpenSearch"' # Replace with your OpenSearch directory

pe 'CLIPBOARD_CONTENT=""'
# Step 1: Open fresh OpenSearch core
pe 'cd "$OPENSEARCH_DIR"'

# Step 2: Find RenameFieldResponseProcessor file and copy it
pe 'RENAME_FIELD_PROCESSOR="./openSearch/modules/search-pipeline-common/src/main/java/org/opensearch/search/pipeline/common/RenameFieldResponseProcessor.java"'
pe 'CLIPBOARD_CONTENT=$(cat "$RENAME_FIELD_PROCESSOR")'

# Step 3: Make a new file DeleteFieldResponseProcessor
pe 'NEW_FILE_PATH="./openSearch/modules/search-pipeline-common/src/main/java/org/opensearch/search/pipeline/common/DeleteFieldResponseProcessor.java"'
pe 'touch "$NEW_FILE_PATH"'

# Step 4: Paste clipboard content into the file
pe 'echo "$CLIPBOARD_CONTENT" > "$NEW_FILE_PATH"'

pe 'cat $NEW_FILE_PATH'

CLIPBOARD=""
R_PROCESSOR="./openSearch/modules/search-pipeline-common/src/main/java/org/opensearch/search/pipeline/common/RenameFieldResponseProcessor.java"

D_PROCESSOR="./openSearch/modules/search-pipeline-common/src/main/java/org/opensearch/search/pipeline/common/DeleteFieldResponseProcessor.java"
P_COMMONS="./openSearch/modules/search-pipeline-common/src/main/java/org/opensearch/search/pipeline/common/SearchPipelineCommonModulePlugin.java"

P_COMMONS_INPUT="./P_COMMONS_INPUT.txt"
D_PROCESSOR_INPUT="./D_PROCESSOR_INPUT.txt"

CLIPBOARD=$(cat "$D_PROCESSOR_INPUT")
> $D_PROCESSOR
echo "$CLIPBOARD" > "$D_PROCESSOR"

> $P_COMMONS
CLIPBOARD=$(cat "$P_COMMONS_INPUT")
echo "$CLIPBOARD" > "$P_COMMONS" 

pe 'diff $D_PROCESSOR $R_PROCESSOR'

# Replace with the command to start the OpenSearch cluster
pe 'cd $OPENSEARCH_DIR'
pe './gradlew localDistro' 

# Create a command to run Gradle
GRADLE_COMMAND="./gradlew run"

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
pe ""

wait
# Step 10: Create a new search pipeline
p "curl -XPUT "http://localhost:9200/_search/pipeline/my_pipeline" -H 'Content-Type: application/json' -d '{"response_processors": [{"rename_field": {"field": "pii","target_field": "hash"}}]}'"
curl -XPUT "http://localhost:9200/_search/pipeline/my_pipeline" -H 'Content-Type: application/json' -d '{"response_processors": [{"rename_field": {"field": "pii","target_field": "hash"}}]}'
pe ""

wait
# Step 11: Create a second search pipeline
p "curl -XPUT "http://localhost:9200/_search/pipeline/my_pipeline2" -H 'Content-Type: application/json' -d '{"response_processors": [{"delete_field": {"field": "pii"}}]}'"
curl -XPUT "http://localhost:9200/_search/pipeline/my_pipeline2" -H 'Content-Type: application/json' -d '{"response_processors": [{"delete_field": {"field": "pii"}}]}'
pe ""

wait
# Step 12: Demo with the first pipeline
p "curl -XGET "http://localhost:9200/test_index/_search?search_pipeline=my_pipeline""
curl -XGET "http://localhost:9200/test_index/_search?search_pipeline=my_pipeline"
pe ""

wait
# Step 13: Demo with the second pipeline
p "curl -XGET "http://localhost:9200/test_index/_search?search_pipeline=my_pipeline2""
curl -XGET "http://localhost:9200/test_index/_search?search_pipeline=my_pipeline2"
p "":
