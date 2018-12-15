#!/bin/bash
# 
# SSL証明書の有効期限をチェックし、結果を出力する

########## 共通処理  ##########

err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

function usage() {
    # 引数のチェック
    if [[ -z $1 ]]; then
        err "Usage: certificate file not found"
        exit 1
    fi
}

###############################

######### メイン処理  #########

function main() {
    
    local certificate_file_path
    local cmd_get_certificate_Info
    local end_date
    local end_date_sec
    local now_sec
    local diff_day

    # 証明書ファイルのpathを設定する
    certificate_file_path="${1}"
    
    usage "${certificate_file_path}"
    
    # 証明書の期限を取得する
    cmd_get_certificate_Info="openssl x509 -noout -text -in ${certificate_file_path}"
    end_date=$(date -d "$( eval ${cmd_get_certificate_Info} | sed -n '/Not After/s/.* : \(.*\)/\1/p')" '+%Y/%m/%d 00:00:00')
    end_date_sec=$(date -d "${end_date}" "+%s")
    
    # 処理日の秒数を取得する
    now_sec=$(date -d "00:00:00" '+%s')
    
    # 証明書の期限日と処理日の差分を取得する
    diff_day=$(( (${end_date_sec} - ${now_sec}) / (24 * 60 * 60) ))
    
    if [[ ${diff_day} -lt 0 ]]; then
        # 有効期限切れ
        notice "証明書の期限が切れています"
    else
        # 有効期限内 
        notice "${diff_day}日後に有効期限が切れます" 
    fi
}

###############################

main "$@"
