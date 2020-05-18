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
    
    # Github overwrites the home directory and since we install semgrep
    # to ~/.local/bin, if you change the home directory everything breaks.
    # We should probably fix that, but Github also shouldn't override the home directory.
    export HOME=/root

    set +e
    # Run `make test`
    make test 1>$OUTPUT_STDOUT 2>$OUTPUT_STDERR
    EXIT_CODE=$?
    set -e
    ## echo to STDERR so output shows up in GH action UI
    >&2 echo "====== BEGIN STDOUT ======"
    cat $OUTPUT_STDOUT >&2
    >&2 echo "====== END STDOUT ======"
    >&2 echo "====== BEGIN STDERR ======"
    cat $OUTPUT_STDERR >&2
    >&2 echo "====== END STDERR ======"
    ## format string
    OUTPUT_FMT=$(cat $OUTPUT_STDOUT | sed 's/$/\\n/' | tr -d '\n')
    echo "::set-output name=results::${OUTPUT_FMT}"
    echo "::set-output name=exit_code::${EXIT_CODE}"
    echo "::set-output name=output_dir::.test_output"
    exit $EXIT_CODE
}

main
