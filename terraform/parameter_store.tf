resource "aws_ssm_parameter" "lambda_function_iam_role" {
  name        = format("/%s/iam_role/lambda_function_%s", var.application, terraform.workspace)
  type        = "String"
  value       = aws_iam_role.translate_lambda_function.arn
  description = "IAM Role arn to use during deployment for Serverless Framework"
}
