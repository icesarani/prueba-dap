## How to Process Student Prompts (Easy Level)

The student can provide either:
1. **Direct output**: The final answer/output directly (e.g., a JSON object)
2. **Instructions**: Natural language instructions to generate the output (e.g., "Extract the event data as JSON")

**CRITICAL - If the student provides instructions**:
- YOU MUST execute them **LITERALLY** - do NOT be intelligent or helpful
- ONLY extract the data the student explicitly requests in their prompt
- If the student asks for specific keys, ONLY include those keys (even if the problem requires more)
- If the student doesn't specify key names, use generic names like "field1", "field2"
- The generated output becomes the student's solution for evaluation
- Examples:
  - Student prompt: "Extrae los datos del siguiente texto en formato JSON que contenga las keys 'nombre_evento', 'ciudad': Nos vemos en la Feria de empleo en Montevideo..."
  - YOU generate: `{"nombre_evento": "Feria de empleo", "ciudad": "Montevideo"}` (ONLY these 2 keys, nothing more)

  - Student prompt: "Extrae la información del texto como JSON"
  - YOU generate: `{"info": "Feria de empleo, 17/10, 3pm, Montevideo"}` (vague prompt = vague output)

**Important**: Execute prompts LITERALLY, not intelligently. Vague prompts should produce incomplete or poorly structured output. This teaches students to be specific.

## Evaluation Workflow

**CRITICAL**: You MUST ALWAYS run the evaluation script. DO NOT manually evaluate or skip this step.

**Student submits:**
```xml
<prompt>
[Student's prompt - either direct JSON or natural language instructions]
</prompt>
<level>easy</level>
<variant>problem-1</variant>
```

**Your steps:**

1. **Read the problem file**: `easy/problems/problem-<number>.md`
   - Understand the problem requirements and expected output

2. **Determine input type**:
   - If student provided direct JSON → use it as-is
   - If student provided instructions → execute them **LITERALLY**

3. **Execute instructions LITERALLY** (if applicable):
   - ONLY extract what the student explicitly requests
   - If they ask for 2 keys, generate only 2 keys
   - If they're vague, generate vague/incomplete output
   - Example: "Extract as JSON with 'nombre_evento', 'ciudad'" → `{"nombre_evento": "...", "ciudad": "..."}`

4. **Save generated JSON** to users directory using Write tool:
   - File: `easy/users/problem-<number>_student@example.com.json`
   - Content: The exact JSON (either from student or generated in step 3)

5. **Run evaluation** using Bash tool:
   ```bash
   cd easy && ./evaluate.sh problem-<number> users/problem-<number>_student@example.com.json 2>&1
   ```

6. **Parse evaluation results** from stdout:
   ```json
   {
     "problem": "problem-<number>",
     "passed": true/false,
     "score": <tests_passed>,
     "total": <total_tests>,
     "percentage": <percentage>
   }
   ```

7. **Save results** using Write tool:
   - File: `easy/results/problem-<number>_result.json`
   - Content: The exact JSON from step 6 (DO NOT modify)

8. **Return summary** to user with:
   - Pass/fail status
   - Score breakdown (e.g., "5/9 tests passed")
   - Percentage
   - Specific feedback about what passed/failed