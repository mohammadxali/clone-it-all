#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <github-username-or-organization> [output-folder]"
  exit 1
fi

USER_OR_ORG=$1
OUTPUT_DIR=${2:-$USER_OR_ORG}

mkdir -p "$OUTPUT_DIR"

gh repo list "$USER_OR_ORG" --limit 4000 | while read -r repo _; do
  gh repo clone "$repo" "$OUTPUT_DIR/$(basename "$repo")"
done