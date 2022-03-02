resource "aws_iam_role" "tfer--translate-function-role-qm7bhoib" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  managed_policy_arns  = ["arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess", "arn:aws:iam::300367504550:policy/service-role/AWSLambdaBasicExecutionRole-a0906d95-65ba-4691-8efa-53b9c61d25e0"]
  max_session_duration = "3600"
  name                 = "translate-function-role-qm7bhoib"
  path                 = "/service-role/"
}
