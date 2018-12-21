#!/bin/bash
# 
# Gitの作成者と更新者を更新する

# メイン処理
main(){
    git filter-branch -f --env-filter '
    if [ "${GIT_AUTHOR_NAME}" = "${1}" ]; then
        local name=${2}
        local email=${3}
        
        export GIT_AUTHOR_NAME=${name}
        export GIT_AUTHOR_EMAIL=${email}
        export GIT_COMMITTER_NAME=${name}
        export GIT_COMMITTER_EMAIL=${email}
    fi'
}

main "$@"
