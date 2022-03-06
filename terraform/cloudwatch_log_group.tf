resource "aws_cloudwatch_log_group" "translate_function" {
  name              = format("/aws/lambda/translate-function-%s", terraform.workspace)
  retention_in_days = 30

  tags = {
    Description = format("CloudWatch log group for creating %s resources", var.application)
  }
}
