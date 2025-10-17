# DAP-ORT Task Evaluation System

Automated evaluation system for student programming tasks at ORT University using Claude Code agents.

## Overview

This system provides deterministic, automated feedback on student prompts by evaluating their solutions against predefined problems. Students submit prompts with their solutions, and the system automatically grades them using evaluation scripts.

## Quick Start

### Prerequisites
- [Claude Code CLI](https://docs.claude.com/en/docs/claude-code)

### Using the DAP-ORT Agent

1. Launch Claude Code in this directory
2. Type `/agents` and select `dap-ort`
3. Submit your solution in this format:

```xml
<prompt>
[Your solution here]
</prompt>

<level>easy</level>
<variant>problem-1</variant>
```

## Project Structure

```
dap-ort-fair-challenges/
├── .claude/
│   └── agents/
│       └── dap-ort.md          # Main evaluation agent
├── easy/                        # Easy level problems (Spanish)
│   ├── problem-1.md            # Data extraction from event text
│   ├── problem-2.md            # Order details extraction
│   ├── problem-3.md            # Medical appointment extraction
│   ├── evaluation-scripts/     # Node.js evaluation scripts
│   ├── Dockerfile              # Docker container for evaluations
│   └── evaluate.sh             # Script to run evaluations
├── medium/                      # Medium level SQL problems (Spanish)
│   ├── problems/
│   │   ├── problem-1.md        # Top Customers by Revenue
│   │   ├── problem-2.md        # Department Salary Analysis
│   │   └── problem-3.md        # Course Enrollment Analysis
│   ├── solution-script/        # Reference SQL solutions
│   ├── scripts/                # Database initialization
│   ├── TestRunner/             # C# test runner application
│   ├── users/                  # Student SQL submissions
│   ├── results/                # Test results output
│   └── docker-compose.yml      # Docker orchestration
└── hard/                        # Hard level problems (empty)
```

## Available Problems

### Easy Level: Data Hunting
Sharpen your text parsing and data extraction skills! In these challenges, you'll hunt for information hidden in unstructured text—like event announcements, order confirmations, and appointment messages—and transform it into clean, structured JSON. Perfect for practicing pattern recognition and data transformation with real-world scenarios.

**Skills practiced:** Text parsing, data extraction, JSON formatting, attention to detail

**Problems:**
- **problem-1**: Data Hunt - Extract structured JSON data from Spanish event text
- **problem-2**: Online Order Extraction - Extract order details from confirmation message
- **problem-3**: Medical Appointment Digital - Extract medical appointment details from confirmation

### Medium Level: Connecting the Puzzle
Learn to retrieve and analyze data from databases by describing what you need in clear, precise language. These SQL challenges teach you that vague requests lead to incomplete results—just like in real development work. Practice translating business questions into accurate database queries.

**Skills practiced:** SQL queries, database analysis, clear technical communication

**Problems:**
- **problem-1**: Top Customers by Revenue - Find top 5 customers by revenue from completed orders
- **problem-2**: Department Salary Analysis - Find employees earning above their department's average
- **problem-3**: Course Enrollment Analysis - Identify courses over 50% capacity

### Hard Level
- Coming soon

## How It Works

### Easy Level Workflow
1. Student submits prompt with level and variant tags
2. Agent reads the corresponding problem file
3. Agent extracts student output from the prompt
4. Docker-based evaluation script runs to compare output against expected results
5. Agent returns score and detailed feedback
6. Results saved to `easy/results/{problem}.json`

### Medium Level Workflow (SQL)
1. Student submits natural language prompt describing the SQL query needed
2. Agent reads the problem file
3. Agent translates prompt literally to SQL (vague prompts will fail!)
4. Agent saves SQL to `medium/users/{variant}-student@example.com.sql`
5. Docker environment executes:
   - Student's generated SQL query
   - Expected solution from reference
   - Comparison of results (columns, rows, data)
6. Agent returns evaluation with pass/fail and detailed feedback
7. Results saved to `medium/results/test_results_<timestamp>.json`

## Running Evaluations

### Easy Level (Docker-based)
```bash
cd easy

# Build the Docker image (first time only)
docker build -t easy-evaluator:latest .

# Run evaluation
./evaluate.sh problem-1 '{"nombre_evento": "Feria de empleo", ...}'
```

### Medium Level (SQL - Docker-based)
```bash
cd medium

# Start SQL Server and initialize database
make init

# Build test runner
make build

# Run all tests
make test

# Run specific problem test
make test-problem-1

# Stop environment
make stop

# Clean up
make clean
```

## Contributing

To contribute new problems or improve evaluation scripts:
1. Follow the problem structure in existing examples
2. Ensure evaluation scripts are deterministic
3. Provide clear error messages for common mistakes
4. Test thoroughly before submitting

## License

For educational use at ORT University.
