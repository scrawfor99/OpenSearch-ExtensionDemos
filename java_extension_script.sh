#!/bin/bash

. ./demo-magic.sh -n

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=30
OS_ROOT="./OpenSearch" # Replace with your OpenSearch directory

function comment() {
  cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  echo -en "$cmd"; echo ""
}

clear
pe

comment "# Enable extensions in OpenSearch" 
pe 'cd $OS_ROOT'
git checkout OSJavaDemo
git reset --hard
./gradlew clean
./gradlew localDistro
cd ..

comment "# Build and run a Java Extension"

JAVA_EXTENSION="./opensearch-sdk-java"
pe 'cd $JAVA_EXTENSION'
git checkout SDKJavaDemo
git reset --hard
cd ..

OPENSEARCH_SDK_DIR="./opensearch-sdk-java" # Replace with your OpenSearch directory

GRADLE_EXT_COMMAND="./gradlew helloWorld"

p 'osascript -e \"tell application \"Terminal\" to do script \"cd $OPENSEARCH_SDK_DIR; $GRADLE_EXT_COMMAND\"\"'
osascript -e "tell application \"Terminal\" to do script \"cd $OPENSEARCH_SDK_DIR; $GRADLE_EXT_COMMAND\""


wait
OPENSEARCH_DIR="./OpenSearch" # Replace with your OpenSearch directory

GRADLE_COMMAND="./gradlew run"

p 'osascript -e \"tell application \"Terminal\" to do script \"cd $OPENSEARCH_DIR; $GRADLE_COMMAND\"\"'
osascript -e "tell application \"Terminal\" to do script \"cd $OPENSEARCH_DIR; $GRADLE_COMMAND\""


wait
pe "curl http://localhost:9200"

wait
curl -XPOST "localhost:9200/_extensions/initialize" -H "Content-Type:application/json" --data @./opensearch-sdk-java/src/main/java/org/opensearch/sdk/sample/helloworld/hello.json

wait
pe "curl -X GET localhost:9200/_extensions/_hello-world-java/hello"
