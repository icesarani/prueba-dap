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
dap-ort-task/
├── easy/                        # Easy level problems
│   ├── problem-1.md            # Data extraction from event text
│   └── problem-2.md            # Order details extraction
├── medium/                      # Medium level problems
├── hard/                        # Hard level problems
└── .claude/agents/
    └── dap-ort.md              # Main evaluation agent
```

## Available Problems

### Easy Level
- **problem-1**: "Caza de Datos" - Extract structured JSON data from Spanish event text
- **problem-2**: "Extracción de Pedido Online" - Extract order details from confirmation message

### Medium Level
- Coming soon

### Hard Level
- Coming soon

## How It Works

1. Student submits prompt with level and variant tags
2. Agent reads the corresponding problem file
3. Agent extracts student output from the prompt
4. Evaluation script runs to compare output against expected results
5. Agent returns score and detailed feedback
6. Results saved to `{level}/{variant}-result.txt`

## Evaluation Scripts

-- TODO

## Contributing

To contribute new problems or improve evaluation scripts:
1. Follow the problem structure in existing examples
2. Ensure evaluation scripts are deterministic
3. Provide clear error messages for common mistakes
4. Test thoroughly before submitting

## License

For educational use at ORT University.
# prueba-dap
