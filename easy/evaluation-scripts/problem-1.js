#!/usr/bin/env node

/**
 * Evaluation script for easy/problem-1: Data Hunt (Caza de Datos)
 * This script evaluates if the student's JSON output matches the expected format and values.
 */

function evaluateJsonResponse(studentOutput, expectedOutput) {
    const errors = [];
    let score = 0;
    const maxScore = Object.keys(expectedOutput).length;

    // Step 1: Try to extract JSON from the output
    let studentJson;
    try {
        // Try to find JSON in the output (it might have extra text)
        const startIdx = studentOutput.indexOf('{');
        const endIdx = studentOutput.lastIndexOf('}');

        if (startIdx === -1 || endIdx === -1) {
            errors.push("ERROR: No JSON object found in the output");
            return { passed: false, score: 0, errors };
        }

        const jsonStr = studentOutput.substring(startIdx, endIdx + 1);
        studentJson = JSON.parse(jsonStr);
    } catch (e) {
        if (e instanceof SyntaxError) {
            errors.push(`ERROR: Invalid JSON format - ${e.message}`);
        } else {
            errors.push(`ERROR: Failed to parse output - ${e.message}`);
        }
        return { passed: false, score: 0, errors };
    }

    // Step 2: Check for required keys
    const missingKeys = [];
    for (const key in expectedOutput) {
        if (!(key in studentJson)) {
            missingKeys.push(key);
            errors.push(`MISSING KEY: '${key}' not found in response`);
        }
    }

    // Step 3: Check values for existing keys
    for (const [key, expectedValue] of Object.entries(expectedOutput)) {
        if (key in studentJson) {
            const studentValue = studentJson[key];
            if (studentValue === expectedValue) {
                score++;
            } else {
                errors.push(`WRONG VALUE: '${key}' = '${studentValue}' (expected: '${expectedValue}')`);
            }
        }
    }

    // Step 4: Check for extra keys (warning only)
    const studentKeys = new Set(Object.keys(studentJson));
    const expectedKeys = new Set(Object.keys(expectedOutput));
    const extraKeys = [...studentKeys].filter(key => !expectedKeys.has(key));

    if (extraKeys.length > 0) {
        errors.push(`WARNING: Extra keys found: ${extraKeys.join(', ')}`);
    }

    // Determine if passed
    const passed = score === maxScore;

    return { passed, score, errors };
}

function main() {
    // Expected output for easy/problem-1
    const expectedOutput = {
        "nombre_evento": "Feria de empleo",
        "fecha": "2025-10-17",
        "hora_inicio": "15:00",
        "ciudad": "Montevideo",
        "stand": "21",
        "email_contacto": "people@crunchloop.io"
    };

    // Read student output from stdin
    let studentOutput = '';

    process.stdin.setEncoding('utf8');

    process.stdin.on('data', (chunk) => {
        studentOutput += chunk;
    });

    process.stdin.on('end', () => {
        // Evaluate the response
        const { passed } = evaluateJsonResponse(studentOutput, expectedOutput);

        // Output JSON result
        const result = {
            "problem": "problem-1",
            "passed": passed
        };

        console.log(JSON.stringify(result, null, 2));

        // Exit with appropriate code (0 for pass, 1 for fail)
        process.exit(passed ? 0 : 1);
    });

    process.stdin.on('error', (err) => {
        console.error(`ERROR: Failed to read input - ${err.message}`);
        process.exit(1);
    });
}

// Run the evaluation
main();