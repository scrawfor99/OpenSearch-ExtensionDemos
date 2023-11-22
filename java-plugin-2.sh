#!/bin/bash
ROOT="$(dirname "$0")"
cd "$ROOT"

source ./demo-magic/demo-magic.sh

DEMO_PROMPT="${GREEN}➜ ${CYAN}\W ${COLOR_RESET}"
TYPE_SPEED=30

function comment() {
  cmd=$DEMO_COMMENT_COLOR$1$COLOR_RESET
  echo -en "$cmd"; echo ""
}

clear
pe

comment "# Call the REST endpoint:"
pe "curl http://localhost:9200/_plugins/hello-world-java"


