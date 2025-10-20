#!/bin/bash

# Script to run easy level evaluations in Docker container
# Usage: ./evaluate.sh <variant> <file_path>
#
# Example:
#   ./evaluate.sh problem-1 users/problem-1_student@example.com.json

VARIANT=$1
FILE_PATH=$2

if [ -z "$VARIANT" ] || [ -z "$FILE_PATH" ]; then
    echo "Usage: $0 <variant> <file_path>"
    echo ""
    echo "Example:"
    echo "  $0 problem-1 users/problem-1_student@example.com.json"
    exit 1
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "ERROR: Docker is not running or not installed"
    echo ""
    echo "Please ensure Docker Desktop is running and try again."
    echo "Visit https://www.docker.com/get-started for installation instructions."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "ERROR: docker-compose is not installed"
    echo ""
    echo "Please install docker-compose and try again."
    echo "Visit https://docs.docker.com/compose/install/ for installation instructions."
    exit 1
fi

# Make path absolute if relative
if [[ "$FILE_PATH" != /* ]]; then
    FILE_PATH="$SCRIPT_DIR/$FILE_PATH"
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "ERROR: File not found: $FILE_PATH"
    exit 1
fi

# Run the evaluation using docker-compose (image should be pre-built)
cd "$SCRIPT_DIR"
cat "$FILE_PATH" | docker-compose --profile test run --rm evaluator "/app/evaluation-scripts/$VARIANT.js"