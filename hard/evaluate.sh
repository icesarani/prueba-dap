#!/bin/bash

# Hard Level Evaluation Script
# Usage: ./evaluate.sh <problem-number>

set -e

PROBLEM=$1

if [ -z "$PROBLEM" ]; then
  echo "Usage: ./evaluate.sh <problem-number>"
  echo "Example: ./evaluate.sh problem-1"
  exit 1
fi

# Extract problem number
PROBLEM_NUM=$(echo "$PROBLEM" | grep -o '[0-9]\+')

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
  echo '{"error": "Docker is not running. Please start Docker and try again."}' >&2
  exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
  echo '{"error": "docker-compose is not installed. Please install it and try again."}' >&2
  exit 1
fi

# Create results directory if it doesn't exist
mkdir -p results

# Build the Docker image if needed
echo "Building Docker image..." >&2
docker-compose build test > /dev/null 2>&1

# Ensure MongoDB is running and healthy
echo "Starting MongoDB..." >&2
docker-compose up -d mongodb > /dev/null 2>&1

# Wait for MongoDB to be healthy
echo "Waiting for MongoDB to be ready..." >&2
MAX_WAIT=30
WAIT_COUNT=0
while [ $WAIT_COUNT -lt $MAX_WAIT ]; do
  if docker-compose ps mongodb | grep -q "healthy"; then
    break
  fi
  sleep 1
  WAIT_COUNT=$((WAIT_COUNT + 1))
done

if [ $WAIT_COUNT -eq $MAX_WAIT ]; then
  echo '{"error": "MongoDB failed to start"}' >&2
  exit 1
fi

# Run the specific test file
echo "Running tests for $PROBLEM..." >&2
TEST_FILE="tests/${PROBLEM}.test.js"

# Run tests and capture output
TEST_OUTPUT=$(docker-compose run --rm test npm test -- "$TEST_FILE" --json 2>&1 || true)

# Parse Jest JSON output
# This is a simplified parser - Jest outputs NDJSON (one JSON per line)
PASSED_TESTS=0
TOTAL_TESTS=0
FAILED_TESTS=()
TEST_DETAILS=()

# Count total and passed tests from Jest output
while IFS= read -r line; do
  if echo "$line" | jq -e '.numPassedTests' > /dev/null 2>&1; then
    PASSED=$(echo "$line" | jq -r '.numPassedTests')
    TOTAL=$(echo "$line" | jq -r '.numTotalTests')
    PASSED_TESTS=$PASSED
    TOTAL_TESTS=$TOTAL
  fi

  if echo "$line" | jq -e '.testResults[0].assertionResults' > /dev/null 2>&1; then
    # Extract individual test results
    TEST_RESULTS=$(echo "$line" | jq -c '.testResults[0].assertionResults[]')
    while IFS= read -r test; do
      TEST_NAME=$(echo "$test" | jq -r '.title')
      TEST_STATUS=$(echo "$test" | jq -r '.status')
      TEST_MESSAGE=$(echo "$test" | jq -r '.failureMessages[0] // ""')

      if [ "$TEST_STATUS" = "passed" ]; then
        TEST_PASSED=true
      else
        TEST_PASSED=false
        FAILED_TESTS+=("$TEST_NAME")
      fi

      TEST_DETAIL=$(jq -n \
        --arg name "$TEST_NAME" \
        --argjson passed "$TEST_PASSED" \
        --arg message "$TEST_MESSAGE" \
        '{name: $name, passed: $passed, message: $message}')
      TEST_DETAILS+=("$TEST_DETAIL")
    done <<< "$TEST_RESULTS"
  fi
done <<< "$TEST_OUTPUT"

# If we couldn't parse Jest output, try to determine from exit code
if [ $TOTAL_TESTS -eq 0 ]; then
  # Fallback: check if tests exist
  TEST_COUNT=$(docker-compose run --rm test sh -c "grep -c '^  test(' $TEST_FILE || true" 2>/dev/null || echo "0")
  TOTAL_TESTS=$TEST_COUNT

  # If all tests would have passed, Jest would exit 0
  if echo "$TEST_OUTPUT" | grep -q "Tests:.*passed"; then
    PASSED_TESTS=$TOTAL_TESTS
  fi
fi

# Determine if all tests passed
if [ $PASSED_TESTS -eq $TOTAL_TESTS ] && [ $TOTAL_TESTS -gt 0 ]; then
  ALL_PASSED=true
else
  ALL_PASSED=false
fi

# Calculate percentage
if [ $TOTAL_TESTS -gt 0 ]; then
  PERCENTAGE=$((PASSED_TESTS * 100 / TOTAL_TESTS))
else
  PERCENTAGE=0
fi

# Determine compilation status (if tests run, compilation passed)
if [ $TOTAL_TESTS -gt 0 ]; then
  COMPILATION="passed"
else
  COMPILATION="failed"
fi

# Build test details JSON array
TESTS_JSON="["
for i in "${!TEST_DETAILS[@]}"; do
  if [ $i -gt 0 ]; then
    TESTS_JSON+=","
  fi
  TESTS_JSON+="${TEST_DETAILS[$i]}"
done
TESTS_JSON+="]"

# Generate simple result JSON with only percentage
RESULT=$(jq -n \
  --argjson percentage "$PERCENTAGE" \
  '{
    score: $percentage
  }')

# Output result to stdout
echo "$RESULT"

# Save result to file in hard/results/
echo "$RESULT" > "results/${PROBLEM}_result.json"

# Exit with appropriate code
if [ "$ALL_PASSED" = "true" ]; then
  exit 0
else
  exit 1
fi
