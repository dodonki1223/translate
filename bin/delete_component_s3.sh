#!/bin/sh

# エラーが発生した時の挙動を設定する
#   -e: エラーが発生したら（exit statusが0以外だったら）スクリプトの実行を終了する
#   -o pipefail: パイプラインの途中でエラーが発生してもスクリプトの実行を終了する
#   ref: https://www.marketechlabo.com/bash-batch-best-practice/
set -e -o pipefail

# 実行スクリプトのフォルダへ移動（この記述をすることで実行場所を選ばないスクリプトになる）
cd `dirname $0`

# 必要のなくなったS3バケット名を入力する事を想定しています
read -p "S3のディレクトリ削除で使用するprofile名を入力してください: " PROFILE_NAME
read -p "tfstateもしくはServerless Frameworkのデプロイ用のS3バケット名を入力して下さい: " BUCKET_NAME

DELETE_S3_PATH="s3://${BUCKET_NAME}/"
printf "\n S3: ${DELETE_S3_PATH}\n\n"
read -p "削除を実行する場合はenterを押して下さい: "

# S3のバケットを削除
printf '\r%-50s' "${BUCKET_NAME}を削除します……"
echo
aws s3 rb ${DELETE_S3_PATH} \
  --profile ${PROFILE_NAME} && \
printf '\r%-50s\n' "${BUCKET_NAME}の削除に成功しました"
