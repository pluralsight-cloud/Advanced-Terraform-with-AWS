resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket_artifact_store.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_artifact"]

      configuration = {
        PollForSourceChanges = false
        RepositoryName       = aws_codecommit_repository.source_code.repository_name
        BranchName           = "master"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_artifact"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.build_project.name
      }
    }
  }
}

resource "aws_s3_bucket" "codepipeline_bucket_artifact_store" {}


data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codepipeline_role" {
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.codepipeline_bucket_artifact_store.arn,
      "${aws_s3_bucket.codepipeline_bucket_artifact_store.arn}/*"
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

resource "aws_cloudwatch_event_rule" "trigger" {
  name        = "trigger-pipeline"
  description = "Triggers the pipeline upon a commit to the 'master' branch"

  event_pattern = jsonencode({
    source = [
      "aws.codecommit"
    ]
    detail-type = [
      "CodeCommit Repository State Change"
    ]
    resources = [
      aws_codecommit_repository.source_code.arn
    ]
    detail = {
      event = [
        "referenceCreated",
        "referenceUpdated"
      ]
      referenceType = [
        "branch"
      ]
      referenceName = [
        "master"
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "trigger" {
  rule      = aws_cloudwatch_event_rule.trigger.name
  target_id = "codepipeline"
  arn       = aws_codepipeline.codepipeline.arn
  role_arn  = aws_iam_role.event_role.arn
}

data "aws_iam_policy_document" "event_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "event_role" {
  assume_role_policy = data.aws_iam_policy_document.event_assume_role.json
}

data "aws_iam_policy_document" "event_policy" {
  statement {
    effect = "Allow"

    actions = [
      "codepipeline:StartPipelineExecution"
    ]

    resources = [
      aws_codepipeline.codepipeline.arn
    ]
  }
}

resource "aws_iam_role_policy" "event_policy" {
  name   = "codepipeline_event_policy"
  role   = aws_iam_role.event_role.id
  policy = data.aws_iam_policy_document.event_policy.json
}
