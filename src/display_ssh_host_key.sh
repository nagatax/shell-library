#!/bin/bash
#
# SSHホスト鍵を表示する

##########################################################
# SSHホスト鍵を表示する
# Returns:
#   0:正常終了
#   0以外:異常終了
##########################################################
function main() {

  # SSH鍵のファイルを取得し、鍵を表示する
  for path in `ls /etc/ssh/ssh_host_*key`
  do
    ssh-keygen -l -f $path
  done
  
  return #?
}

# 実行オプション
set -eu

# メイン処理の実行
main "$@"
