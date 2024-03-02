resource "aws_codebuild_project" "build_project" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = 5
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type     = "CODECOMMIT"
    location = aws_codecommit_repository.source_code.clone_url_http
  }

  source_version = "master"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "BuildProjectRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "permissions" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
  statement {
    effect = "Allow"

    actions = [
      "ec2:*",
      "s3:*",
      "dynamodb:*",
      "kms:*"
    ]

    resources = ["*"]
  }

  statement {
    effect  = "Allow"
    actions = ["codecommit:GitPull"]
    resources = [
      aws_codecommit_repository.source_code.arn
    ]
  }
}

resource "aws_iam_role_policy" "codebuild" {
  role   = aws_iam_role.codebuild.name
  policy = data.aws_iam_policy_document.permissions.json
}
