# DAP-ORT Task Evaluation System

## Project Overview
This is an automated evaluation system for student programming tasks at ORT University. The system uses Claude Code agents to evaluate student prompts against predefined problems and provide deterministic, automated feedback.

## Project Structure
```
dap-ort-fair-challenges/
├── .claude/
│   └── agents/
│       └── dap-ort.md          # Main evaluation agent
├── easy/                        # Easy level problems
│   ├── problems/
│   │   ├── problem-1.md        # Data extraction from event text
│   │   ├── problem-2.md        # Order details extraction
│   │   └── problem-3.md        # Medical appointment extraction
│   ├── evaluation-scripts/     # Evaluation scripts for easy level
│   │   ├── problem-1.js        # Evaluator for problem-1
│   │   ├── problem-2.js        # Evaluator for problem-2
│   │   └── problem-3.js        # Evaluator for problem-3
│   ├── users/                  # Student JSON submissions
│   ├── results/                # Evaluation results output
│   ├── Dockerfile              # Docker container for easy evaluations
│   ├── docker-compose.yml      # Docker compose configuration
│   ├── evaluate.sh             # Script to run evaluations
│   └── INSTRUCTION.md          # Detailed evaluation instructions
├── medium/                      # Medium level SQL problems
│   ├── problems/
│   │   ├── problem_1.md        # Top Customers by Revenue
│   │   ├── problem_2.md        # Department Salary Analysis
│   │   └── problem_3.md        # Course Enrollment Analysis
│   ├── solution-script/
│   │   ├── solution-1.sql      # Solution for problem 1
│   │   ├── solution-2.sql      # Solution for problem 2
│   │   └── solution-3.sql      # Solution for problem 3
│   ├── scripts/
│   │   └── init-db.sql         # Database initialization script
│   ├── TestRunner/
│   │   ├── Program.cs          # C# test runner application
│   │   ├── TestRunner.csproj   # Project configuration
│   │   └── Dockerfile          # Test runner container
│   ├── users/                  # Student SQL submissions
│   ├── results/                # Test results output
│   ├── docker-compose.yml      # Docker orchestration
│   ├── Makefile                # Build and test automation
│   └── INSTRUCTION.md          # Detailed evaluation instructions
├── hard/                        # Hard level problems (empty)
└── CLAUDE.md                    # This file
```

## Available Problems

### Easy Level
1. **problem-1**: "Caza de Datos" - Extract structured JSON data from Spanish event text
2. **problem-2**: "Extracción de Pedido Online" - Extract order details from confirmation message
3. **problem-3**: "Cita Médica Digital" - Extract medical appointment details from confirmation

### Medium Level (SQL Challenges)
1. **problem-1**: "Top Customers by Revenue" - Find top 5 customers by revenue from completed orders
2. **problem-2**: "Department Salary Analysis" - Find employees earning above their department's average
3. **problem-3**: "Course Enrollment Analysis" - Identify courses over 50% capacity

### Hard Level
- No problems defined yet

## How to Use the DAP-ORT Agent

The dap-ort agent evaluates student submissions using this format:

```xml
<prompt>
[Student's solution/prompt goes here]
</prompt>

<level>
[easy|medium|hard]
</level>

<variant>
[problem-1, problem-2, etc.]
</variant>
```

### Example Usage - Easy Level
```xml
<prompt>
{
    "nombre_evento": "Feria de empleo",
    "fecha_iso": "2025-10-17",
    "hora_inicio_24h": "15:00",
    "ciudad": "Montevideo",
    "stand": "21",
    "email_contacto": "people@crunchloop.io"
}
</prompt>

<level>easy</level>
<variant>problem-1</variant>
```

### Example Usage - Medium Level
```xml
<prompt>
Dame los 5 clientes que más gastaron en órdenes completadas
</prompt>

<level>medium</level>
<variant>problem-1</variant>
```

## Evaluation Workflow

### Easy Level Workflow
1. **Student submits prompt** with level and variant tags
2. **Agent reads problem file** from `easy/problems/{variant}.md`
3. **Agent generates JSON output** by executing the student's prompt literally
4. **Agent saves JSON** to `easy/users/{variant}_student@example.com.json`
5. **Runs evaluation script** via docker-compose at `easy/evaluation-scripts/{variant}.js`
6. **Returns results** with score and detailed feedback
7. **Saves results** to `easy/results/{variant}_result.json`

### Medium Level Workflow (SQL)
1. **Student submits natural language prompt** describing the SQL query they want
2. **Agent reads problem file** from `medium/problems/{variant}.md`
3. **Agent translates prompt LITERALLY to SQL** (following INSTRUCTION.md rules)
4. **Agent saves SQL** to `medium/users/{variant}-student@example.com.sql`
5. **Docker environment runs**:
   - Executes student's generated SQL query
   - Executes expected solution from `medium/solution-script/solution-{number}.sql`
   - Compares results (columns, row count, data values)
6. **Returns evaluation** with pass/fail and detailed feedback
7. **Saves results** to `medium/results/test_results_<timestamp>.json`

**Important**: The agent translates prompts LITERALLY, not intelligently. Vague prompts will fail evaluation, teaching students to be more specific.

## Evaluation Scripts

### Easy Level Scripts
Evaluation scripts are written in Node.js and follow this pattern:
- **Input**: Student output via stdin
- **Output**: Evaluation results to stdout
- **Exit code**: 0 for pass, 1 for fail

Scripts provide:
- Score (correct fields / total fields)
- Pass/Fail status
- Detailed error messages for each issue
- Suggestions for improvement

### Medium Level SQL Evaluation
The SQL evaluation uses a Docker-based system:

**Components**:
- **SQL Server**: Microsoft SQL Server 2022 running in Docker
- **Test Runner**: C# application that executes and compares SQL queries
- **Init Script**: Populates database with test data
- **Solution Scripts**: Reference solutions for comparison

**Running Tests**:
```bash
cd medium

# Start SQL Server
make start

# Initialize database with sample data
make init

# Build test runner Docker image
make build

# Run all tests
make test

# Run individual problem tests
make test-problem-1
make test-problem-2
make test-problem-3

# Stop environment
make stop

# Reset database (remove all data and restart)
make reset

# Clean up (remove results and stop containers)
make clean
```

**Environment**:
- Database: `SqlPracticeDB`
- Server: `localhost:1433`
- User: `sa`
- Password: `YourStrong@Passw0rd`

## Adding New Problems

### Easy Level Problems

1. **Create problem file**: `easy/problems/problem-{n}.md`
   - Include clear instructions
   - Provide input text/context
   - Show expected output format
   - Add evaluation script reference

2. **Create evaluation script**: `easy/evaluation-scripts/problem-{n}.js`
   - Define expected output
   - Implement comparison logic
   - Provide helpful error messages
   - Return appropriate exit code

3. **Test the problem**:
   - Run evaluation script with correct input
   - Run evaluation script with incorrect input
   - Test with dap-ort agent

### Medium Level SQL Problems

1. **Create problem file**: `medium/problems/problem-{n}.md`
   - Define the SQL challenge requirements
   - Specify expected output columns
   - Provide hints and table information
   - Include example expected output

2. **Create solution script**: `medium/solution-script/solution-{n}.sql`
   - Write the correct SQL query
   - Ensure it works with test data
   - Follow best practices

3. **Update database schema**: `medium/scripts/init-db.sql` (if needed)
   - Add new tables if required
   - Insert appropriate test data
   - Document the schema

4. **Test the problem**:
   ```bash
   cd medium
   make init
   make build
   make test-problem-{n}
   ```

## Running Evaluations

### Easy Level (Docker Compose)
The easy level uses Docker Compose for evaluation, so Node.js is not required on the host machine.

#### Setup (first time only):
```bash
cd easy

# Build the Docker image using docker-compose
docker-compose build

# Make the evaluation script executable
chmod +x evaluate.sh
```

#### Run evaluations:
```bash
cd easy

# Usage: ./evaluate.sh <variant> <file_path>
./evaluate.sh problem-1 users/problem-1_student@example.com.json
```

The script:
- Checks if Docker is running
- Checks if docker-compose is installed
- Reads JSON from the users directory
- Runs evaluation via docker-compose
- Outputs results to stdout

### Medium Level (Docker-based SQL)
The medium level uses Docker for SQL Server and test execution.

#### Setup (first time only):
```bash
cd medium

# Start SQL Server and initialize database
make init

# Build test runner
make build
```

#### Run evaluations:
```bash
cd medium

# Run all tests
make test

# Or run specific problem test
make test-problem-1
```

## Development Commands

### Use the dap-ort agent:
```bash
# In Claude Code, type:
/agents
# Then select dap-ort and provide the prompt with tags
```

## Docker Environment

### Easy Level
- **Container**: Node.js Alpine-based image
- **Purpose**: Run evaluation scripts in isolated environment
- **Volumes**:
  - Evaluation scripts mounted read-only
  - Users directory mounted read-only
- **Orchestration**: docker-compose with test profile
- **Network**: None (no network access needed)

### Medium Level
The medium level uses a containerized environment for consistent SQL evaluation:

**Services**:
- `sqlserver`: SQL Server 2022 database
- `testrunner`: C# application for running and validating queries

**Volumes**:
- `./scripts`: Database initialization scripts
- `./users`: Student submission folder (read-only)
- `./solution-script`: Reference solutions (read-only)
- `./results`: Test output and results

**Networks**:
- `sql-practice-network`: Bridge network for service communication

**Health Checks**:
- SQL Server has automated health checks to ensure it's ready before tests run

## File Naming Conventions

### Easy Level
- Problems: `problems/problem-{n}.md` (with hyphen)
- Evaluation scripts: `evaluation-scripts/problem-{n}.js` (with hyphen)
- User files: `users/problem-{n}_student@example.com.json` (with underscores)
- Results: `results/problem-{n}_result.json` (with underscores)

### Medium Level
- Problems: `problem-{n}.md` (with underscore)
- Solutions: `solution-{n}.sql` (with hyphen)
- User files: `problem-{n}_<email>.sql` (with underscores)
- Results: `test_results_<timestamp>.json` (with underscores)
