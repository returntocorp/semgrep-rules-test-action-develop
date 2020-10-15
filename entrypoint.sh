#!/bin/sh
set -e

function checkRequired() {
    if [ -z "${1}" ]; then
        echo >&2 "Unable to find the ${2}. Did you set with.${2}?"
        exit 1
    fi
}

function uses() {
    [ ! -z "${1}" ]
}

function usesBoolean() {
    [ ! -z "${1}" ] && [ "${1}" = "true" ]
}

function main() {
    echo "" # see https://github.com/actions/toolkit/issues/168

    OUTPUT_DIR=".test_output"
    OUTPUT_STDOUT="${OUTPUT_DIR}/stdout.txt"
    OUTPUT_STDERR="${OUTPUT_DIR}/stderr.txt"
    OUTPUT_TEST_STDOUT="${OUTPUT_DIR}/stdout_test.txt"
    OUTPUT_TEST_STDERR="${OUTPUT_DIR}/stderr_test.txt"

    # Github overwrites the home directory and since we install semgrep
    # to ~/.local/bin, if you change the home directory everything breaks.
    # We should probably fix that, but Github also shouldn't override the home directory.
    export HOME=/root

    mkdir -p $OUTPUT_DIR

    set +e
    # Run `make test`
    make test 1>$OUTPUT_TEST_STDOUT 2>$OUTPUT_TEST_STDERR
    # Run 'make output'
    make output 1>$OUTPUT_STDOUT 2>$OUTPUT_STDERR
    EXIT_CODE=$?
    set -e
    ## echo test results to STDERR so output shows up in GH action UI
    >&2 echo "====== BEGIN TEST STDOUT ======"
    cat $OUTPUT_TEST_STDOUT >&2
    >&2 echo "====== END TEST STDOUT ======"
    >&2 echo "====== BEGIN TEST STDERR ======"
    cat $OUTPUT_TEST_STDERR >&2
    >&2 echo "====== END TEST STDERR ======"
    ## echo output results to STDERR so output shows up in GH action UI
    >&2 echo "====== BEGIN OUTPUT STDOUT ======"
    cat $OUTPUT_STDOUT >&2
    >&2 echo "====== END OUTPUT STDOUT ======"
    >&2 echo "====== BEGIN OUTPUT STDERR ======"
    cat $OUTPUT_STDERR >&2
    >&2 echo "====== END OUTPUT STDERR ======"
    ## copy the examples tar file into the $PWD
    cp /src/semgrep_runs_output.tar.gz /github/workspace/semgrep_runs_output.tar.gz
    # format string
    OUTPUT_FMT=$(cat $OUTPUT_TEST_STDOUT | sed 's/$/\\n/' | tr -d '\n')
    echo "::set-output name=results::${OUTPUT_FMT}"
    echo "::set-output name=exit_code::${EXIT_CODE}"
    echo "::set-output name=output_dir::.test_output"
    exit $EXIT_CODE
}

main
