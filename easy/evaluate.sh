#!/bin/bash

# Script to run easy level evaluations in Docker container
# Usage: ./evaluate.sh <variant>
# Example: ./evaluate.sh problem-1
#
# Note: The script expects the student output to be in easy/outputs/<variant>-output.json

VARIANT=$1

if [ -z "$VARIANT" ]; then
    echo "Usage: $0 <variant>"
    echo "Example: $0 problem-1"
    echo ""
    echo "The script will read from: easy/outputs/${VARIANT}-output.json"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if output file exists
OUTPUT_FILE="$SCRIPT_DIR/outputs/${VARIANT}-output.json"
if [ ! -f "$OUTPUT_FILE" ]; then
    echo "ERROR: Output file not found at $OUTPUT_FILE"
    echo "Please create the output file first with your solution."
    exit 1
fi

# Build the Docker image if needed (from the easy directory)
cd "$SCRIPT_DIR" && docker build -t easy-evaluator:latest . > /dev/null 2>&1

# Run the evaluation in container with outputs directory mounted
docker run --rm \
    -v "$SCRIPT_DIR/outputs:/app/outputs:ro" \
    easy-evaluator:latest \
    "/app/evaluation-scripts/$VARIANT.js"