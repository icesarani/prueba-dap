#!/bin/bash

# Script to run easy level evaluations in Docker container
# Usage: ./evaluate.sh <variant> <student_output>
# Example: ./evaluate.sh problem-1 '{"key":"value"}'

VARIANT=$1
STUDENT_OUTPUT=$2

if [ -z "$VARIANT" ] || [ -z "$STUDENT_OUTPUT" ]; then
    echo "Usage: $0 <variant> <student_output>"
    echo "Example: $0 problem-1 '{\"key\":\"value\"}'"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Build the Docker image if needed (from the easy directory)
cd "$SCRIPT_DIR" && docker build -t easy-evaluator:latest . > /dev/null 2>&1

# Run the evaluation in container
echo "$STUDENT_OUTPUT" | docker run -i --rm easy-evaluator:latest "/app/evaluation-scripts/$VARIANT.js"