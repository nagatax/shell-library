#!/bin/bash
#
# HTTPのヘッダ情報を表示する

##########################################################
# HTTPのヘッダ情報を表示する
#
# Arguments:
#   1:Origin属性
#   2:URI
# Returns:
#   0:正常終了
#   0以外:異常終了
##########################################################
get_http_header(){

  local origin=${1}
  local uri=${2}

  curl -X GET -I -H "Origin: "$origin $uri

  return $#
}

main() {
  #get_http_header "127.0.0.1" "http://192.168.34.21/index.html"
  get_http_header ${1} ${2}
}

# メイン処理の実行
main "$@"

