resource "aws_ssm_parameter" "lambda_function_iam_role" {
  name        = format("/%s/iam_role/lambda_function_%s", var.application, terraform.workspace)
  type        = "String"
  value       = aws_iam_role.translate_lambda_function.arn
  description = "IAM Role arn to use during deployment for Serverless Framework"
}

// NOTE: パラメータストアを参照してロググループ名を Serverless Framework でも使えるようにする
resource "aws_ssm_parameter" "lambda_function_log_group" {
  name        = format("/%s/log/translate_function_%s", var.application, terraform.workspace)
  type        = "String"
  value       = local.log_group_name
  description = "CloudWatch Log group name to use during deployment for Serverless Framework"
}
