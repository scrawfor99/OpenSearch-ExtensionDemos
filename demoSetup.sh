#!/bin/bash
cd "$(dirname "$0")"

git clone https://github.com/paxtonhare/demo-magic.git

git clone https://github.com/opensearch-project/OpenSearch.git

git clone https://github.com/dblock/opensearch-hello-plugin-java

git clone https://github.com/scrawfor99/opensearch-sdk-java.git

git clone https://github.com/opensearch-project/opensearch-sdk-py.git

cd OpenSearch
./gradlew localDistro
cd ..
