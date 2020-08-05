#!/bin/sh

if [ -z $GITHUB_PAT ]; then
    echo "Error : You need to set GITHUB_PAT environment variable."
    exit 1
fi

if [ -z $GITHUB_OWNER ]; then
    echo "Error : You need to set the GITHUB_OWNER environment variable."
    exit 1
fi

registration_url="https://github.com/${GITHUB_OWNER}"
if [ -z "${GITHUB_REPOSITORY}" ]; then
    token_url="https://api.github.com/orgs/${GITHUB_OWNER}/actions/runners/registration-token"
else
    token_url="https://api.github.com/repos/${GITHUB_OWNER}/${GITHUB_REPOSITORY}/actions/runners/registration-token"
    registration_url="${registration_url}/${GITHUB_REPOSITORY}"
fi

echo "Requesting token at '${token_url}'"

payload=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" ${token_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)

./config.sh \
    --name $(hostname) \
    --token ${RUNNER_TOKEN} \
    --url ${registration_url} \
    --work ${RUNNER_WORKDIR} \
    --labels ${RUNNER_LABELS} \
    --unattended \
    --replace

remove() {
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./runsvc.sh "$*" &

wait $!
