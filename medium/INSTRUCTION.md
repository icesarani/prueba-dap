## How to Process Student Prompts (Medium Level - SQL)

**CRITICAL RULE**: Your job is to translate the student's prompt LITERALLY to SQL, NOT to solve the problem correctly.

The student will provide natural language instructions (in Spanish or English) describing what they want to query.

**Translation Rules** - Generate SQL based on ONLY what the student explicitly mentioned:
- If student says "customers by revenue" but doesn't explain HOW to calculate revenue → generate simple `ORDER BY Revenue` (even if a Revenue column doesn't exist)
- If student doesn't mention joining tables → DON'T add joins
- If student doesn't mention specific calculations → DON'T add SUM/GROUP BY unless they said to
- If student doesn't mention filtering → DON'T add WHERE clauses unless they specified it
- If student says "top 5" but the problem needs "top 5 with calculation" → generate LIMIT 5 without calculation

**DO NOT fill in missing details from the problem description** - The evaluation system will compare your generated SQL with the correct solution, and that's where the student learns if their prompt was good enough.

**Your goal**: Make vague/incomplete prompts fail evaluation so students learn to be more specific next time.

**Examples**:
- Student: "top 5 customers by revenue" → Generate: `SELECT * FROM Customers ORDER BY Revenue DESC LIMIT 5` (will FAIL evaluation ✗)
- Student: "top 5 customers, sum quantity times price from OrderDetails joined with Orders on OrderID, joined with Customers on CustomerID, where status completed" → Generate complete query (will PASS evaluation ✓)

## Evaluation Process

- Read the problem file from `medium/problems/<variant>.md` (e.g., `medium/problems/problem-1.md`)
- You must:
    1. Understand the problem requirements from the problem file (for context only, don't use to improve the student's SQL)
    2. Translate the student's prompt LITERALLY to SQL
    3. Extract the problem number from variant (e.g., "problem_1" -> "medium/problems/problem_1.md")
    4. Save the generated SQL query to `medium/users/problem_<number>_student@example.com.sql`
    5. Ensure docker is running with `cd medium && make init` (only if database not initialized)
    6. Build and run tests: `cd medium && make build && make test`
    7. The test runner will:
        - Execute your generated SQL query against the database
        - Execute the expected solution from `medium/solution-script/solution-<number>.sql`
        - Compare the results
        - Save results to `medium/results/test_results_<timestamp>.json`
    8. Read the latest results file from `medium/results/` and present the evaluation to the user
    9. The script will output JSON with the evaluation result: `{"problem": "<variant>", "passed": true/false}` and save it to `medium/results/<variant>-result.json`
    10. The script exits with code 0 (pass) or 1 (fail)

## Example for Medium Level:
For `<level>medium</level>` and `<variant>problem-1</variant>`:
```
Student prompt: "Dame los 5 clientes que más gastaron en órdenes completadas"

1. Read `medium/problems/problem-1.md` to understand requirements
2. Generate SQL query based on the student's prompt and problem requirements
3. Save generated SQL to `medium/users/problem-1_student@example.com.sql`
4. Run `cd medium && make build && make test`
5. Read results from `medium/results/test_results_*.json`
6. Compare student query with solution at `medium/solution-script/solution-1.sql`
7. Save summary to `medium/results/problem-1-result.json`
8. Present evaluation to user
```