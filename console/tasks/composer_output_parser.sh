#!/usr/bin/env bash
set -eu

OUTPUT_UPDATE_PREFIX="- "

INSTALL_TYPE="Installing"
UPDATE_TYPE="Updating"
DOWNGRADE_TYPE="Downgrading"
REMOVE_TYPE="Removing"

getUpdatesFromOutput()
{
	COMPOSER_OUTPUT=$1

    UPDATES_OUTPUT=$(echo "$COMPOSER_OUTPUT" | grep -e "${OUTPUT_UPDATE_PREFIX}${INSTALL_TYPE}" \
     -e "${OUTPUT_UPDATE_PREFIX}${UPDATE_TYPE}" \
     -e "${OUTPUT_UPDATE_PREFIX}${DOWNGRADE_TYPE}" \
     -e "${OUTPUT_UPDATE_PREFIX}${REMOVE_TYPE}" || echo "")
	echo "$UPDATES_OUTPUT"
}

getLineWithoutType()
{
	LINE=$1
	TYPES=$2

	LINE_WITHOUT_UPDATE_TYPE=""
	for TYPE in ${TYPES}
	do
		if [[ "${LINE}" == *"${OUTPUT_UPDATE_PREFIX}${TYPE}"* ]]; then
  			LINE_WITHOUT_UPDATE_TYPE=${LINE#*${OUTPUT_UPDATE_PREFIX}${TYPE} }
  			break
		fi
	done
	echo "${LINE_WITHOUT_UPDATE_TYPE}"
}

removeColorCodes()
{
    DEPENDENCY_NAME=$1

    # Remove composer output ASCII color codes "^[[32m" "^[[39m"
    SANITIZED=$(echo "${DEPENDENCY_NAME}" | tr -cd 'A-Za-z0-9_./-' | sed -e 's/^32m//g' -e 's/39m$//g')
    echo ${SANITIZED}
}

getUpdatedDependenciesByTypes()
{
	TYPES=$1
	UPDATES_OUTPUT=$2
	PREFIX_PATH=${3%/}

   	UPDATED_DEPENDENCIES=""
	while read LINE
	do
		LINE_WITHOUT_UPDATE_TYPE=$(getLineWithoutType "${LINE}" "${TYPES}")
		if [ "${LINE_WITHOUT_UPDATE_TYPE}" == "" ]; then
			continue
		fi
		DEPENDENCY_NAME=${LINE_WITHOUT_UPDATE_TYPE%% (*}
		SANITIZED_DEPENDENCY_NAME=$(removeColorCodes "${DEPENDENCY_NAME}")
		UPDATED_DEPENDENCIES="${UPDATED_DEPENDENCIES} ${PREFIX_PATH}/${SANITIZED_DEPENDENCY_NAME}"
	done <<< "${UPDATES_OUTPUT}"
	echo "${UPDATED_DEPENDENCIES}"
}

getUpdatedDependencies()
{
    UPDATES_OUTPUT=$1
    PREFIX_PATH=$2

    UPDATED_DEPENDENCIES=$(getUpdatedDependenciesByTypes "${INSTALL_TYPE} ${UPDATE_TYPE} ${DOWNGRADE_TYPE}" "${UPDATES_OUTPUT}" "${PREFIX_PATH}")
    echo "${UPDATED_DEPENDENCIES}"
}

getRemovedDependencies()
{
    UPDATES_OUTPUT=$1
    PREFIX_PATH=$2

    REMOVED_DEPENDENCIES=$(getUpdatedDependenciesByTypes "${REMOVE_TYPE}" "${UPDATES_OUTPUT}" "${PREFIX_PATH}")
    echo "${REMOVED_DEPENDENCIES}"
}
