locals {
  // NOTE: Serverless Framework で CloudWatch Log group を作成するため、Terraform と一緒に管理はできない
  //       CloudFormation がそもそも外部で作成された CloudWatch Log group の変更ができないためである
  //       なので CloudWatch Log group は Serverless Framework で作成させるため名前だけ共有で使えるようにする
  log_group_name = format("/aws/lambda/translate-function-%s", terraform.workspace)
}
