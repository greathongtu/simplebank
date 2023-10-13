#!/bin/bash

set -e
# Check if the correct number of arguments are provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

input_file="$1"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
  echo "Error: Input file not found."
  exit 1
fi

# Use base64 to encode the content of the input file
base64_encoded_content=$(base64 < "$input_file")

# Print the base64-encoded content
echo "$base64_encoded_content"


# use something like "$base64_encoded_content | base64 --decode > .env"
