# DAP-ORT Task Evaluation System

## Project Overview
This is an automated evaluation system for student programming tasks at ORT University. The system uses Claude Code agents to evaluate student prompts against predefined problems and provide deterministic, automated feedback.

## Project Structure
```
dap-ort-task/
├── .claude/
│   └── agents/
│       └── dap-ort.md          # Main evaluation agent
├── easy/                        # Easy level problems
│   ├── problem-1.md            # Data extraction from event text
│   ├── problem-2.md            # Order details extraction
│   ├── problem-3.md            # Medical appointment extraction
│   ├── evaluation-scripts/     # Evaluation scripts for easy level
│   │   ├── problem-1.js        # Evaluator for problem-1
│   │   ├── problem-2.js        # Evaluator for problem-2
│   │   └── problem-3.js        # Evaluator for problem-3
│   ├── Dockerfile              # Docker container for easy evaluations
│   ├── docker-compose.yml      # Docker compose configuration
│   └── evaluate.sh             # Script to run evaluations
├── medium/                      # Medium level problems
│   └── problem-1.md            # Debug assistance prompt writing
├── hard/                        # Hard level problems (empty)
└── CLAUDE.md                    # This file
```

## Available Problems

### Easy Level
1. **problem-1**: "Caza de Datos" - Extract structured JSON data from Spanish event text
2. **problem-2**: "Extracción de Pedido Online" - Extract order details from confirmation message
3. **problem-3**: "Cita Médica Digital" - Extract medical appointment details from confirmation

### Medium Level
1. **problem-1**: "Pedirle ayuda al senior" - Write a professional debugging help request

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

### Example Usage
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

## Evaluation Workflow

1. **Student submits prompt** with level and variant tags
2. **Agent reads problem file** from `{level}/{variant}.md`
3. **Agent extracts student output** from the prompt
4. **Runs evaluation script** at `{level}/evaluation-scripts/{variant}.js`
5. **Returns results** with score and detailed feedback
6. **Saves results** to `{level}/{variant}-result.txt`

## Evaluation Scripts

Evaluation scripts are written in Node.js and follow this pattern:
- **Input**: Student output via stdin
- **Output**: Evaluation results to stdout
- **Exit code**: 0 for pass, 1 for fail

Scripts provide:
- Score (correct fields / total fields)
- Pass/Fail status
- Detailed error messages for each issue
- Suggestions for improvement

## Adding New Problems

To add a new problem:

1. **Create problem file**: `{level}/problem-{n}.md`
   - Include clear instructions
   - Provide input text/context
   - Show expected output format
   - Add evaluation script reference

2. **Create evaluation script**:
   - For easy level: `easy/evaluation-scripts/problem-{n}.js`
   - For medium/hard: Different evaluation methods (TBD)
   - Define expected output
   - Implement comparison logic
   - Provide helpful error messages
   - Return appropriate exit code

3. **Test the problem**:
   - Run evaluation script with correct input
   - Run evaluation script with incorrect input
   - Test with dap-ort agent

## Running Evaluations

### Easy Level (Docker-based)
The easy level uses Docker containers for evaluation, so Node.js is not required on the host machine.

#### Setup (first time only):
```bash
cd easy

# Build the Docker image
docker build -t easy-evaluator:latest .

# Make the evaluation script executable
chmod +x evaluate.sh
```

#### Run evaluations:
```bash
cd easy

# Usage: ./evaluate.sh <variant> '<student_output>'
./evaluate.sh problem-1 '{"nombre_evento": "Feria de empleo", "fecha_iso": "2025-10-17", "hora_inicio_24h": "15:00", "ciudad": "Montevideo", "stand": "21", "email_contacto": "people@crunchloop.io"}'
```

### Medium and Hard Levels
These levels will have their own evaluation methods (to be implemented).

## Development Commands

### Use the dap-ort agent:
```bash
# In Claude Code, type:
/agents
# Then select dap-ort and provide the prompt with tags
```