#!/bin/bash

# Script to run easy level evaluations in Docker container
# Usage: ./evaluate.sh <variant> <student_output>
# Example: ./evaluate.sh problem-1 '{"key":"value"}'

# VARIANT=$1
# STUDENT_OUTPUT=$2

# if [ -z "$VARIANT" ] || [ -z "$STUDENT_OUTPUT" ]; then
#     echo "Usage: $0 <variant> <student_output>"
#     echo "Example: $0 problem-1 '{\"key\":\"value\"}'"
#     exit 1
# fi

# # Get the directory where this script is located
# SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# # Build the Docker image if needed (from the easy directory)
# cd "$SCRIPT_DIR" && docker build -t easy-evaluator:latest . > /dev/null 2>&1

# # Run the evaluation in container
# echo "$STUDENT_OUTPUT" | docker run -i --rm easy-evaluator:latest "/app/evaluation-scripts/$VARIANT.js"

#!/bin/bash

# Script to run easy level evaluations
# Usage: ./evaluate.sh <variant> <student_output>
# Example: ./evaluate.sh problem-1 '{"key":"value"}'

set -e  # Exit on error

VARIANT=$1
STUDENT_OUTPUT=$2

if [ -z "$VARIANT" ] || [ -z "$STUDENT_OUTPUT" ]; then
    echo '{"error":"Missing arguments","usage":"./evaluate.sh <variant> <student_output>"}' >&2
    exit 1
fi

# Validate variant format (alphanumeric, dash, underscore)
if ! [[ "$VARIANT" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "{\"error\":\"Invalid variant format\",\"variant\":\"$VARIANT\"}" >&2
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if evaluation script exists
EVAL_SCRIPT="$SCRIPT_DIR/evaluation-scripts/$VARIANT.js"
if [ ! -f "$EVAL_SCRIPT" ]; then
    echo "{\"error\":\"Evaluation script not found\",\"variant\":\"$VARIANT\"}" >&2
    exit 1
fi

# Run the evaluation script with Node.js
# Student output is passed via stdin
echo "$STUDENT_OUTPUT" | node "$EVAL_SCRIPT"
EXIT_CODE=$?

# Exit with the same code as the evaluation script
exit $EXIT_CODE