#!/bin/bash

set -eux

COMMIT_FILE="packages/prometheus-federator/generated-changes/dependencies/helmProjectOperator/dependency.yaml"
TEMP_FILE="_tmp.file"

if [[ "${1}" != "undefined" ]]
then

	sed "s/^commit: .*/commit: ${1}/" "${COMMIT_FILE}" > "${TEMP_FILE}"
	mv "${TEMP_FILE}" "${COMMIT_FILE}"

	go get -u github.com/rancher/helm-project-operator@"${1}" >&2
	go mod tidy >&2
	git diff
fi


exit 0

