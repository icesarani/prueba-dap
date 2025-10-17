#!/usr/bin/env node

/**
 * Evaluation script for easy/problem-3: Medical Appointment (Cita Médica Digital)
 * This script evaluates if the student's JSON output matches the expected format and values.
 */

/**
 * Test 1: Parse and validate JSON format
 */
function testValidJsonFormat(studentOutput, errors) {
    try {
        const startIdx = studentOutput.indexOf('{');
        const endIdx = studentOutput.lastIndexOf('}');

        if (startIdx === -1 || endIdx === -1) {
            errors.push("ERROR: No JSON object found in the output");
            return { passed: false, studentJson: null };
        }

        const jsonStr = studentOutput.substring(startIdx, endIdx + 1);
        const studentJson = JSON.parse(jsonStr);
        return { passed: true, studentJson };
    } catch (e) {
        if (e instanceof SyntaxError) {
            errors.push(`ERROR: Invalid JSON format - ${e.message}`);
        } else {
            errors.push(`ERROR: Failed to parse output - ${e.message}`);
        }
        return { passed: false, studentJson: null };
    }
}

/**
 * Test 2: Check if the number of keys matches expected
 */
function testCorrectKeyCount(studentJson, expectedOutput, errors) {
    const expectedKeyCount = Object.keys(expectedOutput).length;
    const studentKeyCount = Object.keys(studentJson).length;

    if (studentKeyCount === expectedKeyCount) {
        return true;
    } else {
        errors.push(`WRONG KEY COUNT: Expected ${expectedKeyCount} keys, got ${studentKeyCount}`);
        return false;
    }
}

/**
 * Test 3: Check for extra (unexpected) keys
 */
function testNoExtraKeys(studentJson, expectedOutput, errors) {
    const studentKeys = new Set(Object.keys(studentJson));
    const expectedKeys = new Set(Object.keys(expectedOutput));
    const extraKeys = [...studentKeys].filter(key => !expectedKeys.has(key));

    if (extraKeys.length === 0) {
        return true;
    } else {
        errors.push(`EXTRA KEYS: ${extraKeys.join(', ')}`);
        return false;
    }
}

/**
 * Test 4+: Check each field value (with type-specific handling)
 */
function testFieldValues(studentJson, expectedOutput, errors) {
    let correctValues = 0;

    for (const [key, expectedValue] of Object.entries(expectedOutput)) {
        if (key in studentJson) {
            const studentValue = studentJson[key];

            // Special handling for different data types
            if (typeof expectedValue === 'number' && typeof studentValue === 'number') {
                // For numbers, allow small floating point differences
                if (Math.abs(studentValue - expectedValue) < 0.01) {
                    correctValues++;
                } else {
                    errors.push(`WRONG VALUE: '${key}' = ${studentValue} (expected: ${expectedValue})`);
                }
            } else if (typeof expectedValue === 'boolean') {
                // For booleans, strict comparison
                if (studentValue === expectedValue) {
                    correctValues++;
                } else {
                    errors.push(`WRONG VALUE: '${key}' = ${studentValue} (expected: ${expectedValue})`);
                }
            } else {
                // For strings and other types
                if (studentValue === expectedValue) {
                    correctValues++;
                } else {
                    errors.push(`WRONG VALUE: '${key}' = '${studentValue}' (expected: '${expectedValue}')`);
                }
            }
        } else {
            errors.push(`MISSING KEY: '${key}' not found in response`);
        }
    }

    return correctValues;
}

/**
 * Main evaluation function
 */
function evaluateJsonResponse(studentOutput, expectedOutput) {
    const errors = [];
    let testsPassed = 0;
    const totalTests = 3 + Object.keys(expectedOutput).length;

    // Test 1: Valid JSON format
    const { passed: jsonValid, studentJson } = testValidJsonFormat(studentOutput, errors);
    if (!jsonValid) {
        return { passed: false, score: 0, total: totalTests, errors };
    }
    testsPassed++;

    // Test 2: Correct number of keys
    if (testCorrectKeyCount(studentJson, expectedOutput, errors)) {
        testsPassed++;
    }

    // Test 3: No extra keys
    if (testNoExtraKeys(studentJson, expectedOutput, errors)) {
        testsPassed++;
    }

    // Tests 4+: Each field value is correct
    const correctValues = testFieldValues(studentJson, expectedOutput, errors);
    testsPassed += correctValues;

    // Determine if passed (100% of tests)
    const passed = testsPassed === totalTests;

    return { passed, score: testsPassed, total: totalTests, errors };
}

function main() {
    // Expected output for easy/problem-3
    const expectedOutput = {
        "nombre": "María",
        "doctor": "Dr. Mendez",
        "dia_semana": "miércoles",
        "dia_mes": 30,
        "mes": "octubre",
        "hora": "14:30",
        "lugar": "Hospital Británico",
        "minutos_antes": 15,
        "costo": 1800,
        "telefono": "2487-3000"
    };

    // Read student output from stdin
    let studentOutput = '';

    process.stdin.setEncoding('utf8');

    process.stdin.on('data', (chunk) => {
        studentOutput += chunk;
    });

    process.stdin.on('end', () => {
        // Evaluate the response
        const { passed, score, total } = evaluateJsonResponse(studentOutput, expectedOutput);
        const percentage = Math.round((score / total) * 100);

        // Output JSON result
        const result = {
            "problem": "problem-3",
            "passed": passed,
            "score": score,
            "total": total,
            "percentage": percentage
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