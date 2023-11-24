#!/bin/bash
cd "$(dirname "$0")"

git clone https://github.com/paxtonhare/demo-magic.git

git clone https://github.com/opensearch-project/OpenSearch.git

git clone https://github.com/dblock/opensearch-hello-plugin-java

git clone https://github.com/opensearch-project/opensearch-sdk-java.git

git clone https://github.com/opensearch-project/opensearch-sdk-py.git

git clone https://github.com/opensearch-project/k-NN.git

cd OpenSearch
./gradlew localDistro
cd ..

cd k-NN
./gradlew assemble
cd ..

cd opensearch-sdk-py
poetry install
cd ..