#!/bin/sh

GIT_URL="$(git config --get remote.origin.url | sed 's/.git$//')"
if [ -z "$GIT_URL" ]; then
    echo "Not running from a git repository"
    GIT_URL="null"
    GIT_REPO="null"
    RELATIVE_PATH=$PWD
else
    GIT_REPO=$(basename -s .git `git config --get remote.origin.url`)
    RELATIVE_PATH=$(echo $PWD | awk -F"/$GIT_REPO/" '{print $2}')
fi

TERRAFORM="terraform: `terraform --version | head -1 | cut -d ' ' -f 2`"
DATE=`date`
RUNNER_INFO=$(echo "hostname: `hostname` ID: `whoami`")

function error_exit() {
    echo "$1" 1>&2
    exit 1
}

function check_dependencies() {
    test -f $(which jq) || error_exit "jq command not detected in path, please install it"
}

function produce_output() {
    jq -n \
    --arg git_url "$GIT_URL" \
    --arg git_path "$RELATIVE_PATH" \
    --arg iac_platform "$TERRAFORM" \
    --arg runner_info "$RUNNER_INFO" \
    --arg last_update "$DATE" \
    '{"git_url":$git_url, "git_path":$git_path, "iac_platform":$iac_platform, "runner_info":$runner_info ,"last_update":$last_update}'
}

## Main body
check_dependencies
produce_output