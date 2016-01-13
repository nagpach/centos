#!/usr/bin/env bash

script_directory=$1

if [ -z "$script_directory" ]; then
  echo "NO script directory given. Exiting..."
  exit 1
fi

for file in $(find "$script_directory" -type f | sort --human-numeric-sort); do
  if [ -x "$file" ]; then
    echo "Running command \"$file\"." >&2
    bash -c "$file"
  else
    echo "File \"$file\" is not executable. I'm going to ignore it." >&2
  fi
done
