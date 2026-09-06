#!/bin/bash

set -u

IMAGE_NAME="${IMAGE_NAME:-diagnostic}"
PASSED_TESTS=0
FAILED_TESTS=0

run_cli() {
    LAST_OUTPUT=$(docker run --rm "$IMAGE_NAME" "$@" 2>&1)
    LAST_EXIT_CODE=$?
}

assert_cli() {
    local test_name=$1
    local expected_exit_code=$2
    local expected_text=$3
    shift 3

    run_cli "$@"
    if [ "$LAST_EXIT_CODE" -eq "$expected_exit_code" ] && [[ "$LAST_OUTPUT" == *"$expected_text"* ]]; then
        printf ' \033[0;32m[PASS]\033[0m %s\n' "$test_name"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        printf ' \033[0;31m[FAIL]\033[0m %s\n' "$test_name"
        printf '    Expected exit code: %s, text: %s\n' "$expected_exit_code" "$expected_text"
        printf '    Actual exit code: %s\n    Actual output: %s\n' "$LAST_EXIT_CODE" "$LAST_OUTPUT"
        FAILED_TESTS=$((FAILED_TESTS + 1))
    fi
}

echo "========================================="
echo "Starting Docker Image Validation Tests"
echo "Target Image: $IMAGE_NAME"
echo "========================================="

assert_cli "Invalid command returns exit code 1" 1 "Invalid option" invalid_command
assert_cli "System command returns system information" 0 "Hostname:" system
assert_cli "Disk command returns disk usage" 0 "Disk usage" disk
assert_cli "Help command displays usage" 0 "Usage:" help
assert_cli "Network without host returns exit code 2" 2 "host cannot be empty" network
assert_cli "Network with valid host resolves and checks connectivity" 0 "Connectivity check" network google.com
assert_cli "Network with unknown host fails" 1 "Failed to resolve" network invalid-host-that-does-not-exist-12345.com

echo ""
echo "========================================="
echo "Test Summary"
echo "========================================="
echo "Passed Tests: $PASSED_TESTS"
echo "Failed Tests: $FAILED_TESTS"
echo "Total Tests: $((PASSED_TESTS + FAILED_TESTS))"
echo "========================================="

if [ "$FAILED_TESTS" -eq 0 ]; then
    echo "All tests passed!"
    exit 0
fi

echo "Some tests failed."
exit 1
