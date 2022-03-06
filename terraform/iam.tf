data "aws_iam_policy_document" "translate_cloudwatch" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:ListMetrics",
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "translate_log_group" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [format("arn:aws:logs:%s:%s:*", var.aws_region, var.account_id)]
  }
}

data "aws_iam_policy_document" "translate_create_log_group" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [format("arn:aws:logs:%s:%s:log-group:%s:*", var.aws_region, var.account_id, aws_cloudwatch_log_group.translate_function.name)]
  }
}

data "aws_iam_policy_document" "translate_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets",
      "s3:ListBucket"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "translate_iam" {
  statement {
    effect = "Allow"
    actions = [
      "iam:GetRole",
      "iam:ListRoles"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "translate_policy" {
  statement {
    effect = "Allow"
    actions = [
      "comprehend:DetectDominantLanguage",
      "translate:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "translate_lambda" {
  source_policy_documents = [
    data.aws_iam_policy_document.translate_cloudwatch.json,
    data.aws_iam_policy_document.translate_log_group.json,
    data.aws_iam_policy_document.translate_create_log_group.json,
    data.aws_iam_policy_document.translate_s3.json,
    data.aws_iam_policy_document.translate_iam.json,
    data.aws_iam_policy_document.translate_policy.json
  ]
}

resource "aws_iam_policy" "translate_lambda_function" {
  name        = format("translate-function-%s-policy", terraform.workspace)
  policy      = data.aws_iam_policy_document.translate_lambda.json
  description = format("Provides translate-lambda-function-%s DynamoDB, CloudWatch, CloudWatch LogGroup, S3, IAM, Translate", terraform.workspace)
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "translate_lambda_function" {
  name               = format("translate-function-%s-role", terraform.workspace)
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  description        = "Provide translate-lambda-function iam role"
}

resource "aws_iam_role_policy_attachment" "translate_lambda_function" {
  role       = aws_iam_role.translate_lambda_function.name
  policy_arn = aws_iam_policy.translate_lambda_function.arn
}

data "aws_iam_policy" "dynamodb_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.translate_lambda_function.name
  policy_arn = data.aws_iam_policy.dynamodb_full_access.arn
}
