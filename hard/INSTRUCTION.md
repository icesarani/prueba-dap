## How to Process Student Prompts (Hard Level - Bug Fixing)

**CRITICAL RULE**: Your job is to translate the student's natural language instructions LITERALLY into code changes, NOT to intelligently fix all bugs.

The student will provide natural language instructions (in Spanish or English) describing how to fix a bug in an API endpoint.

**Translation Rules** - Apply code changes based on ONLY what the student explicitly mentioned:
- If student says "change the variable name" but doesn't specify error handling → DON'T add error handling
- If student doesn't mention edge cases → DON'T add edge case handling
- If student doesn't mention specific validation → DON'T add validation logic
- If student says "fix the endpoint" without specifics → make minimal changes
- If student doesn't mention async/await but uses promises → keep promises
- If student is vague about the fix → generate incomplete/partial fix

**DO NOT intelligently solve the entire bug** - The evaluation system will run tests to check if the fix works, and that's where the student learns if their prompt was specific enough.

**Your goal**: Make vague/incomplete prompts fail tests so students learn to be more specific and thorough.

**Examples**:
- Student: "arregla el endpoint de usuarios" → Make minimal change without proper fix (will FAIL tests ✗)
- Student: "en el endpoint GET /api/users, cambia la query de la base de datos para usar await con User.find() en vez de User.findOne(), y asegurate de manejar el error con try-catch devolviendo status 500" → Generate complete fix (will PASS tests ✓)

## Evaluation Workflow

**CRITICAL**: You MUST ALWAYS run the evaluation tests via Docker. DO NOT manually evaluate or skip this step.

**Student submits:**
```xml
<prompt>
[Student's natural language instructions to fix the bug]
</prompt>
<level>hard</level>
<variant>problem-1</variant>
```

**Your steps:**

1. **Read the problem file**: `hard/problems/problem-<number>.md`
   - Understand what bug the student needs to fix
   - See the error messages and symptoms they would observe
   - Understand the expected behavior

2. **Process the student's prompt LITERALLY**:
   - Only make the code changes the student explicitly requests
   - If they're vague, make minimal/incomplete changes
   - If they're specific, implement exactly what they describe
   - DO NOT add extra improvements or fixes they didn't mention

3. **Apply code changes to YOUR LOCAL FILESYSTEM**:
   - Read the buggy application code from `hard/app/` using Read tool
   - Apply the student's described changes to the appropriate files
   - **CRITICAL**: Use Edit or Write tools to save the modified files back to `hard/app/`
   - **The changes MUST be written to the local filesystem BEFORE running Docker**
   - Example: If changing `hard/app/routes/users.js`, use Edit tool to modify it

4. **Verify changes were saved**:
   - You can verify by reading the file again to confirm changes were applied
   - The file in `hard/app/` should reflect your modifications

5. **Run evaluation tests** using Bash tool:
   ```bash
   cd hard && ./evaluate.sh problem-<number> 2>&1
   ```
   - Docker will mount `hard/app/` and see your changes
   - The tests will run against your modified code

6. **Parse evaluation results** from stdout:

   The script outputs a simple JSON with only the score percentage:
   ```json
   {
     "score": 100
   }
   ```

   Where `score` is a percentage from 0 to 100:
   - `0` = 0% (0/5 tests passed)
   - `20` = 20% (1/5 tests passed)
   - `40` = 40% (2/5 tests passed)
   - `60` = 60% (3/5 tests passed)
   - `80` = 80% (4/5 tests passed)
   - `100` = 100% (5/5 tests passed)

7. **Results are automatically saved**:
   - The evaluate.sh script automatically saves to `hard/results/problem-<number>_result.json`
   - You don't need to save manually
   - The file will contain: `{"score": <percentage>}`

8. **Return summary** to user:
   - Show the score percentage
   - Indicate pass (100%) or fail (<100%)
   - Keep feedback concise

## Important Notes

- The application is a Node.js/Express API with intentional bugs
- Each problem has a specific buggy endpoint
- Students see compilation errors or runtime errors when hitting endpoints
- Tests validate that the bug is actually fixed
- Vague prompts should result in incomplete fixes that fail tests
- This teaches students to be precise in describing code changes
