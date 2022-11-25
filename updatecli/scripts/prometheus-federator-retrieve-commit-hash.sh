#!/bin/bash

set -eux

FILE="charts/helm-project-operator/values.yaml"
VERSION=$(git blame -l $FILE | grep -A 1 rancher/shell | grep tag)
COMMIT=$(echo $VERSION | awk -F" " '{ print $1 }')
TAG=$(echo $VERSION | awk -F"tag: " '{ print $2 }')

if [[ "${TAG}" == "${1}" ]]
then
	git rev-list "${COMMIT}"..main
else
	echo "undefined"
fi

exit 0

