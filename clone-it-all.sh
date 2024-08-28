#!/bin/bash

usage() {
  echo "Usage: clone-it-all <github-username-or-organization> [output-folder] [--with-forks]"
  exit 1
}

if [ -z "$1" ]; then
  usage
fi

USER_OR_ORG=$1
OUTPUT_DIR=${2:-$USER_OR_ORG}
WITH_FORKS=false

if [ "$3" == "--with-forks" ]; then
  WITH_FORKS=true
fi

mkdir -p "$OUTPUT_DIR"

if [ "$WITH_FORKS" = true ]; then
  gh repo list "$USER_OR_ORG" --limit 4000 --json name --jq '.[] | .name' | while read -r repo; do
    gh repo clone "$USER_OR_ORG/$repo" "$OUTPUT_DIR/$repo"
  done
else
  gh repo list "$USER_OR_ORG" --limit 4000 --json name,isFork --jq '.[] | select(.isFork == false) | .name' | while read -r repo; do
    gh repo clone "$USER_OR_ORG/$repo" "$OUTPUT_DIR/$repo"
  done
fi