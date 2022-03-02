resource "aws_iam_policy" "tfer--AWSLambdaBasicExecutionRole-a0906d95-65ba-4691-8efa-53b9c61d25e0" {
  name = "AWSLambdaBasicExecutionRole-a0906d95-65ba-4691-8efa-53b9c61d25e0"
  path = "/service-role/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "iam:GetRole",
        "s3:ListAllMyBuckets",
        "translate:*",
        "iam:ListRoles",
        "s3:ListBucket",
        "comprehend:DetectDominantLanguage",
        "cloudwatch:GetMetricStatistics",
        "s3:GetBucketLocation",
        "cloudwatch:ListMetrics"
      ],
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "VisualEditor0"
    },
    {
      "Action": "logs:CreateLogGroup",
      "Effect": "Allow",
      "Resource": "arn:aws:logs:ap-northeast-1:300367504550:*",
      "Sid": "VisualEditor1"
    },
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:logs:ap-northeast-1:300367504550:log-group:/aws/lambda/translate-function:*",
      "Sid": "VisualEditor2"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}
