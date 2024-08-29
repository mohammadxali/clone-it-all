#!/bin/bash

SCRIPT_NAME="clone-it-all"

usage() {
  cat <<EOF
Usage: $SCRIPT_NAME <github-username-or-organization> [OPTIONS]

Clone all repositories from a specified GitHub user or organization.

Options:
  --with-forks             Include forked repositories in the clone operation.
  --output <output-folder> Specify the output folder where repositories will be cloned.
  --help                   Show this help message and exit.

Examples:
  $SCRIPT_NAME someusername
    Clones all non-fork repositories from 'someusername' into a folder named 'someusername'.

  $SCRIPT_NAME someusername --with-forks
    Clones all repositories, including forks, from 'someusername' into a folder named 'someusername'.

  $SCRIPT_NAME someusername --output /path/to/output-folder
    Clones all non-fork repositories from 'someusername' into '/path/to/output-folder'.

  $SCRIPT_NAME someusername --with-forks --output /path/to/output-folder
    Clones all repositories, including forks, from 'someusername' into '/path/to/output-folder'.
EOF
  exit 1
}

USER_OR_ORG=""
OUTPUT_DIR=""
WITH_FORKS=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-forks)
      WITH_FORKS=true
      shift
      ;;
    --output)
      if [[ -n "$2" && ! "$2" =~ ^-- ]]; then
        OUTPUT_DIR="$2"
        shift 2
      else
        echo "Error: --output requires a non-empty option argument."
        usage
      fi
      ;;
    --help)
      usage
      ;;
    -*|--*)
      echo "Unknown option: $1"
      usage
      ;;
    *)
      if [[ -z "$USER_OR_ORG" ]]; then
        USER_OR_ORG="$1"
        shift
      else
        echo "Error: Multiple positional arguments provided: '$USER_OR_ORG' and '$1'."
        usage
      fi
      ;;
  esac
done

if [[ -z "$USER_OR_ORG" ]]; then
  echo "Error: GitHub username or organization is required."
  usage
fi

OUTPUT_DIR=${OUTPUT_DIR:-$USER_OR_ORG}

mkdir -p "$OUTPUT_DIR" || { echo "Error: Failed to create directory '$OUTPUT_DIR'."; exit 1; }

if ! command -v gh &> /dev/null; then
  echo "Error: GitHub CLI ('gh') is not installed. Please install it and authenticate."
  exit 1
fi

if [ "$WITH_FORKS" = true ]; then
  echo "Cloning all repositories (including forks) from '$USER_OR_ORG' into '$OUTPUT_DIR'..."
  gh repo list "$USER_OR_ORG" --limit 4000 --json name --jq '.[] | .name' | while read -r repo; do
    gh repo clone "$USER_OR_ORG/$repo" "$OUTPUT_DIR/$repo"
  done
else
  echo "Cloning all non-fork repositories from '$USER_OR_ORG' into '$OUTPUT_DIR'..."
  gh repo list "$USER_OR_ORG" --limit 4000 --json name,isFork --jq '.[] | select(.isFork == false) | .name' | while read -r repo; do
    gh repo clone "$USER_OR_ORG/$repo" "$OUTPUT_DIR/$repo"
  done
fi

echo "Cloning completed."