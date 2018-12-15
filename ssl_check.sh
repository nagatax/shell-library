#!/bin/bash
# SSL証明書の有効期限をチェックし、結果を出力する

########## 共通処理  ##########

# 通知する
function notice() {
    echo $1
}

###############################

######### メイン処理  #########

# 証明書ファイルのpathを設定する
certFilePath="${1}"

# 引数のチェック
if [ -z "${certFilePath}" ]
then
    echo "Usage: certificate file not found"
    exit 1
fi

# 証明書の期限を取得する
cmdGetCertInfo="openssl x509 -noout -text -in ${certFilePath}"
endDate=$(date -d "$( eval ${cmdGetCertInfo} | sed -n '/Not After/s/.* : \(.*\)/\1/p')" '+%Y/%m/%d 00:00:00')
endDate_sec=$(date -d "${endDate}" "+%s")

# 処理日の秒数を取得する
now_sec=$(date -d "00:00:00" '+%s')

# 証明書の期限日と処理日の差分を取得する
diff_day=$(( (${endDate_sec} - ${now_sec}) / (24 * 60 * 60) ))

if [ ${diff_day} -lt 0 ]; then
    # 有効期限切れ
    notice "証明書の期限が切れています"
else
    # 有効期限内 
    notice "${diff_day}日後に有効期限が切れます" 
fi

###############################
