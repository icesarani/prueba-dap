## How to Process Student Prompts (Easy Level)

The student can provide either:
1. **Direct output**: The final answer/output directly (e.g., a JSON object)
2. **Instructions**: Natural language instructions to generate the output (e.g., "Extract the event data as JSON")

**If the student provides instructions**:
- YOU MUST execute them and generate the expected output
- Use your capabilities to process the student's request and produce the output they asked for
- Example: Student says "Extract event data as JSON from this text: ..." → You generate the JSON and that becomes the student's output for evaluation

## Evaluation Process

- Check if an evaluation script exists at `easy/evaluation-scripts/<variant>.js`
- Run the evaluation using Docker from the easy directory:
    ```bash
    cd easy && ./evaluate.sh <variant> '<student_output>'
    ```
- The script will output JSON with the evaluation result: `{"problem": "<variant>", "passed": true/false}`
- The script exits with code 0 (pass) or 1 (fail)

## Example:
For `<level>easy</level>` and `<variant>problem-1</variant>`:
1. Read `easy/problem-1.md` to understand the problem
2. Process the student's prompt:
   - If it's a JSON object → use it directly
   - If it's instructions like "Extract event data as JSON..." → execute the instructions and generate the JSON
3. Run `cd easy && ./evaluate.sh problem-1 '<json_output>'`
4. Save the JSON result to `easy/problem-1-result.json`