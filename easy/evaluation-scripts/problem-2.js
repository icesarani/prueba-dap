#!/usr/bin/env node

/**
 * Evaluation script for easy/problem-2: Online Order Extraction
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
 * Test 4+: Check each field value (with number tolerance)
 */
function testFieldValues(studentJson, expectedOutput, errors) {
    let correctValues = 0;

    for (const [key, expectedValue] of Object.entries(expectedOutput)) {
        if (key in studentJson) {
            const studentValue = studentJson[key];
            // For numbers, allow small floating point differences
            if (typeof expectedValue === 'number' && typeof studentValue === 'number') {
                if (Math.abs(studentValue - expectedValue) < 0.01) {
                    correctValues++;
                } else {
                    errors.push(`WRONG VALUE: '${key}' = ${studentValue} (expected: ${expectedValue})`);
                }
            } else if (studentValue === expectedValue) {
                correctValues++;
            } else {
                errors.push(`WRONG VALUE: '${key}' = '${studentValue}' (expected: '${expectedValue}')`);
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
    // Expected output for easy/problem-2
    const expectedOutput = {
        "numero_orden": "ORD-2024-8934",
        "cantidad_items": 3,
        "subtotal": 2489.99,
        "descuento_porcentaje": 10,
        "costo_envio": 15.00,
        "total": 2255.99,
        "codigo_postal": "11300",
        "fecha_entrega_iso": "2025-10-22",
        "ultimos_digitos_tarjeta": "4782"
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
            "problem": "problem-2",
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