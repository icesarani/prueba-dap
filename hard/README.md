# Hard Level - Bug Fixing Challenges

This level tests students' ability to debug and fix issues in a Node.js/Express API application.

## Overview

Students are presented with buggy API endpoints and must provide natural language instructions to fix them. The system translates their instructions LITERALLY into code changes and runs automated tests to validate the fix.

## Problems

### Problem 1: Usuario no encontrado
- **File**: `hard/problems/problem-1.md`
- **Bug**: GET /api/users/:id always returns 404
- **Root cause**: Query doesn't use findById and missing await
- **Tests**: 5 tests

### Problem 2: Error al crear producto
- **File**: `hard/problems/problem-2.md`
- **Bug**: POST /api/products crashes with "Cannot read property 'save' of undefined"
- **Root cause**: Missing 'new' keyword and 'await' when creating Product
- **Tests**: 6 tests

### Problem 3: Actualización de stock incorrecta
- **File**: `hard/problems/problem-3.md`
- **Bug**: PATCH /api/products/:id/stock doesn't update the stock value
- **Root cause**: Doesn't read body, doesn't assign value, doesn't save
- **Tests**: 7 tests

## Architecture

```
hard/
├── app/                    # Node.js/Express application
│   ├── server.js          # Main server file
│   ├── models/            # Mongoose models
│   │   ├── User.js
│   │   └── Product.js
│   └── routes/            # API routes (with bugs)
│       ├── users.js
│       └── products.js
├── tests/                 # Jest test suites
│   ├── problem-1.test.js
│   ├── problem-2.test.js
│   └── problem-3.test.js
├── problems/              # Problem descriptions
├── solutions/             # Solution descriptions
├── evaluate.sh            # Evaluation script
├── docker-compose.yml     # Docker orchestration
└── Makefile              # Build automation
```

## Setup

### Prerequisites
- Docker and Docker Compose
- Make (optional, for using Makefile commands)

### Quick Start

```bash
# Initialize environment
make init

# Or manually
docker-compose up -d mongodb
```

## Running Tests

### Using Makefile (recommended)

```bash
# Run all tests
make test

# Run specific problem tests
make test-problem-1
make test-problem-2
make test-problem-3
```

### Using evaluate.sh

```bash
# Run evaluation for a specific problem
./evaluate.sh problem-1
./evaluate.sh problem-2
./evaluate.sh problem-3
```

## Evaluation Process

1. Student submits natural language instructions to fix a bug
2. Agent reads the problem file to understand the bug
3. Agent applies changes LITERALLY based on student's instructions
4. Evaluation script runs Jest tests against the modified code
5. Results are returned with pass/fail status and detailed feedback

## Output Format

```json
{
  "problem": "problem-1",
  "passed": true,
  "score": 5,
  "total": 5,
  "percentage": 100,
  "details": {
    "compilation": "passed",
    "tests": [
      {
        "name": "El endpoint compila sin errores",
        "passed": true,
        "message": ""
      }
    ]
  }
}
```

## Development

### Start application server

```bash
make start
# Application runs on http://localhost:3000
```

### View logs

```bash
make logs
```

### Clean up

```bash
make clean
```

### Reset environment

```bash
make reset
```

## Key Features

- **Literal Prompt Translation**: Vague prompts result in incomplete fixes
- **Automated Testing**: Jest integration for deterministic evaluation
- **Docker Isolation**: Consistent environment across runs
- **MongoDB Integration**: Real database for testing CRUD operations
- **Detailed Feedback**: Per-test results showing exactly what passed/failed

## Teaching Philosophy

Students learn to be precise by experiencing the consequences of vague instructions. If they say "fix the endpoint" without specifics, the system makes minimal changes that fail tests. This teaches them to:

1. Identify the exact file and function to modify
2. Specify the exact changes needed (e.g., "add await", "change findOne to findById")
3. Include error handling and validation
4. Think about edge cases

## Notes

- All bugs are intentional and pedagogically designed
- Tests are comprehensive and cover happy paths and edge cases
- Solutions are documented in `solutions/` directory
- Each problem has a different complexity level and bug type
