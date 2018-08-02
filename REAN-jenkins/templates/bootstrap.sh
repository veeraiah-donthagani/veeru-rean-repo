#!/bin/bash

if [ -n "$RHEL_USERNAME" ] && [ -n "$RHEL_PASSWORD" ]; then
	echo "Registering with RedHat..."
	subscription-manager register --type="${RHEL_UNIT:-system}" --auto-attach \
		--username="$RHEL_USERNAME" --password="$RHEL_PASSWORD" || exit 1
fi

set -x

if [ -n "$ENABLE_YUM_REPOS" ]; then
	for name in $ENABLE_YUM_REPOS; do
		yum-config-manager --enable $name
	done
fi