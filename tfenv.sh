#!/bin/bash
#
# This script will check:
# - If current directory is a git repo directory
# - If this git repo has remotes, defined in $ENABLED_GIT_REMOTES (this way you can limit execution to the specified repositories only)
# - If there is a .terraform-version file present
# - That installed terraform binary doesn't match the one, specified in .terraform-version
# If any of the above is false, the execution will stop
#
# Otherwise, the script will:
# - Download version, specified in .terraform-version if it is not stored already in $TF_ZIP_DIR
# - Install that version
# 
# Add alias to the ~/.bashrc for more convenient use, e.g. "alias tfc='bash /github_repositories/terraform/tfenv.sh'"

ENABLED_GIT_REMOTES=(git@github.com:capterra/terraform.git) # Use this to add repositories, on which that scripts should be executed. Other repositories will be omitted.
TF_ZIP_DIR="${HOME}/.local/share/terraform/tXenv/tfbin"     # You can change it to the value of your choosing
TF_BIN_TMP_DIR="${HOME}/.local/share/terraform/tXenv/tfbin" # You can change it to the value of your choosing

mkdir -p $TF_ZIP_DIR $TF_BIN_TMP_DIR

function is_a_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}


function is_a_repo_match() {
  GIT_REMOTE=$(git config --get remote.origin.url 2>/dev/null)

  if [[ ! " ${ENABLED_GIT_REMOTES[*]} " =~ " ${GIT_REMOTE} " ]]; then
    return 1
  fi
}


function is_there_a_tf_version_file() {
  if [ ! -f .terraform-version ]; then
    return 1
  fi
}


function get_tf_binary() {
  TF_VERSION=$1
  TF_ZIP_DIR=$2
  TF_ZIP="terraform_${TF_VERSION}_linux_amd64.zip"

  TF_ZIP_URL="https://releases.hashicorp.com/terraform/${TF_VERSION}/$TF_ZIP"
  TF_SHA256SUM_URL="https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_SHA256SUMS"

  wget --no-verbose -P $TF_ZIP_DIR $TF_ZIP_URL
  wget --no-verbose -P $TF_ZIP_DIR $TF_SHA256SUM_URL
  SHA256SUM_FILE=$(sha256sum $TF_ZIP_DIR/$TF_ZIP | cut -d' ' -f1)
  SHA256SUM_RECORDED=$(grep $TF_ZIP $TF_ZIP_DIR/terraform_${TF_VERSION}_SHA256SUMS | cut -d' ' -f1)
  if [ $SHA256SUM_FILE != $SHA256SUM_RECORDED ]; then
    echo SHA256SUM DOES NOT MATCH
    rm $TF_ZIP_DIR/$TF_ZIP $TF_ZIP $TF_ZIP_DIR/terraform_${TF_VERSION}_SHA256SUMS
    return 1
  fi
}


function versions_dont_match() {
  TF_VERSION=$1
  TF_CURRENT_VERSION=$(terraform version | head -n 1 | cut -d' ' -f2 | tr -d 'v')
  if [ $TF_VERSION == $TF_CURRENT_VERSION ]; then
    return 1
  fi
}

function is_there_local_tf_binary() {
  TF_VERSION=$1
  TF_ZIP_DIR=$2
  TF_ZIP="terraform_${TF_VERSION}_linux_amd64.zip"
  if [ ! -f $TF_ZIP_DIR/$TF_ZIP ]; then
    return 1
  fi
}

function switch_binary() {
  TF_VERSION=$1
  TF_ZIP_DIR=$2
  TF_BIN_TMP_DIR=$3
  TF_BIN_DIR=$(which terraform | rev | cut -d/ -f2- | rev)
  TF_ZIP="terraform_${TF_VERSION}_linux_amd64.zip"
  unzip $TF_ZIP_DIR/$TF_ZIP terraform -d $TF_BIN_TMP_DIR >/dev/null
  chmod +x $TF_BIN_TMP_DIR/terraform
  sudo mv $TF_BIN_TMP_DIR/terraform $TF_BIN_DIR
}


is_a_git_repo && is_a_repo_match && is_there_a_tf_version_file && TF_VERSION=$(cat .terraform-version) && versions_dont_match $TF_VERSION || exit

is_there_local_tf_binary $TF_VERSION $TF_ZIP_DIR || get_tf_binary $TF_VERSION $TF_ZIP_DIR && switch_binary $TF_VERSION $TF_ZIP_DIR $TF_BIN_TMP_DIR
terraform -version | head -n 1
