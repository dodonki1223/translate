/*
  aws_cloudformation_export の export name を調べるには以下のコマンドを実行することで調べることができる
    $ aws cloudformation list-exports
  以下のような書きぶりで Serverless Framework で作成した資材の情報を取得することができる
  Terraform と Serverless Framework の連携ではデプロイ順番を気にしないと取得できない可能性もあるので注意が必要

data "aws_cloudformation_export" "lambda_function_arn" {
  name = format("lambda-function-arn-%s", terraform.workspace)
}

data "aws_cloudformation_export" "lambda_function_name" {
  name = format("lambda-function-name-%s", terraform.workspace)
}

data "aws_cloudformation_export" "lambda_function_qualified_arn" {
  name = format("sls-translate-function-%s-TranslateLambdaFunctionQualifiedArn", terraform.workspace)
}

data "aws_cloudformation_export" "lambda_layer_qualified_arn" {
  // Serverless Framework で作成されるここの文字列がどうやって作られているのか謎
  // 変な感じですごく気持ち悪い……
  name = format("TranslateDashfunctionDash%sDashpythonDashdefaultLambdaLayerQualifiedArn", terraform.workspace)
}

output "lambda_function_arn" {
  value = data.aws_cloudformation_export.lambda_function_arn.value
}

output "lambda_function_name" {
  value = data.aws_cloudformation_export.lambda_function_name.value
}

output "lambda_function_qualified_arn" {
  value = data.aws_cloudformation_export.lambda_function_qualified_arn.value
}

output "lambda_layer_qualified_arn" {
  value = data.aws_cloudformation_export.lambda_layer_qualified_arn.value
}
 */
