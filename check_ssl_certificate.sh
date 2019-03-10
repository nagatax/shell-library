#!/bin/bash
#
# SSL証明書の有効期限をチェックし、結果を出力する

########## 共通処理  ##########

notice() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@"
}

err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

usage() {
    # 引数のチェック
    if [[ -z $1 ]]; then
        err "Usage: certificate file not found"
        exit 1
    fi
}

# SSL証明書の情報を取得する
ssl_infomation() {
    openssl x509 -noout -text -in ${1}    |
        sed -n "/${2}/s/.* : \(.*\)/\1/p"
}

# 秒数へ変換する
convert_sec() {
    if [ -p /dev/stdin ]; then
        date -f "${1}" "+%s"
    else
        date -d "${1}" "+%s"
    fi
}

###############################

######### メイン処理  #########

main() {
    # 入力値チェック
    usage "$@"
    
    local ssl_after_date_sec 
    ssl_after_date_sec=$( ssl_infomation "${1}" "Not After" | convert_sec - )

    local now_sec
    now_sec=$( convert_sec  )

    local diff_day
    diff_day=$(( (${ssl_after_date_sec} - ${now_sec}) / (24 * 60 * 60) ))
    
    if [[ ${diff_day} -lt 0 ]]; then
        # 有効期限切れ
        notice "証明書の期限が切れています"
    else
        # 有効期限内 
        notice "${diff_day}日後に有効期限が切れます" 
    fi
}

###############################

# メイン処理の実行
main "$@"

