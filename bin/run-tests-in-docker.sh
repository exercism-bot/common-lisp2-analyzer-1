#!/usr/bin/env sh

# Synopsis:
# Test the analyzer Docker image by running it against a predefined set of 
# solutions with an expected output.
# The analyzer Docker image is built automatically.

# Output:
# Outputs the diff of the expected analysis against the actual analysis
# generated by the analyzer Docker image.

# Example:
# ./bin/run-tests-in-docker.sh

# Stop executing when a command returns a non-zero return code
set -e

# Build the Docker image
docker build --rm -t exercism/common-lisp2-analyzer .

# Run the Docker image using the settings mimicking the production environment
docker run \
    --rm \
    --network none \
    --read-only \
    --mount type=bind,src="${PWD}/tests",dst=/opt/analyzer/tests \
    --mount type=tmpfs,dst=/tmp \
    --volume "${PWD}/bin/run-tests.sh:/opt/analyzer/bin/run-tests.sh" \
    --workdir /opt/analyzer \
    --entrypoint /opt/analyzer/bin/run-tests.sh \
    exercism/common-lisp2-analyzer
