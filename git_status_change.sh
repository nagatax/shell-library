#!/bin/bash
#
# Gitの作成者と更新者を更新する

##########################################################
# Gitの作成者と更新者を更新する
# Globals:
#   GIT_AUTHOR_NAME:     作成者名
#   GIT_AUTHOR_EMAIL:    作成者のメールアドレス
#   GIT_COMMITTER_NAME:  コミッタ名
#   GIT_COMMITTER_EMAIL: コミッタのメールアドレス
# Arguments:
#   1:更新対象の作成者名
#   2:更新後の氏名
#   3:更新後のメールアドレス
# Returns:
#   0:正常終了
#   0以外:異常終了
##########################################################
function main() {

  git filter-branch -f --env-filter '
  echo $GIT_AUTHOR_NAME
  if [ ${GIT_AUTHOR_NAME} = ${1} ]; then
    local name=${2}
    local email=${3}
    
    export GIT_AUTHOR_NAME=${name}
    export GIT_AUTHOR_EMAIL=${email}
    export GIT_COMMITTER_NAME=${name}
    export GIT_COMMITTER_EMAIL=${email}
  fi'

  return #?
}

# 実行オプション
set -eu

# メイン処理の追加
main "$@"
