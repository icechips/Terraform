#codepipeline resource
resource "aws_codepipeline" "bakery_codepipeline" {
    
    name     = "${local.ClientName}-${var.EnvName}-${local.App}-codepipeline"
    role_arn = aws_iam_role.AWSCodePipelineServiceRole_bakery.arn

    artifact_store {
    location = aws_s3_bucket.bakery_codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        BranchName           = var.branch_name
        ConnectionArn        = var.connection_arn
        FullRepositoryId     = var.full_repository_id
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]
      version          = "1"

      configuration = {
        ProjectName = "${local.ClientName}-${var.EnvName}-${local.App}-codebuild-project"
      }
    }
  }

  depends_on = [aws_iam_role.AWSCodePipelineServiceRole_bakery,aws_s3_bucket.bakery_codepipeline_bucket]

}

#codebuild resource
resource "aws_codebuild_project" "bakery_codebuild_project" {
  name          = "${local.ClientName}-${var.EnvName}-${local.App}-codebuild-project"
  service_role  = aws_iam_role.AWSCodeBuild_base_bakery.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type     = "NO_CACHE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:4.0"
    type         = "LINUX_CONTAINER"

    /*environment_variable {
      name  = var.aws_monitor_environment_variable_ASSUME_ROLE_ARN_name
      value = var.aws_monitor_environment_variable_ASSUME_ROLE_ARN_value
      type  = var.aws_monitor_environment_variable_ASSUME_ROLE_ARN_type
    }*/
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
    }
  }

  source {
    buildspec       = "build.yml"
    type            = "CODEPIPELINE"
    git_clone_depth = "0"
  }

  tags = {
    Env  = var.EnvName
    App  = local.App
  }

depends_on = [aws_iam_role.AWSCodeBuild_base_bakery]

}

#codepipeline bucket
resource "aws_s3_bucket" "bakery_codepipeline_bucket" {
  bucket = "${local.ClientName}-${var.EnvName}-${local.App}-bucket"

  tags = {
    Env  = var.EnvName
    App  = local.App
  }
}


#CodePileline role / policy
resource "aws_iam_role" "AWSCodePipelineServiceRole_bakery" {
  name = "${local.ClientName}-${var.EnvName}-${local.App}-codepipeline-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "AWSCodePipelineServiceRole_bakery_policy" {
  name = "${local.ClientName}-${var.EnvName}-${local.App}-codepipeline-service-role-policy"

  policy = <<EOF
{
    "Statement": [
        {
            "Action": [
                "iam:PassRole"
            ],
            "Resource": "*",
            "Effect": "Allow",
            "Condition": {
                "StringEqualsIfExists": {
                    "iam:PassedToService": [
                        "cloudformation.amazonaws.com",
                        "elasticbeanstalk.amazonaws.com",
                        "ec2.amazonaws.com",
                        "ecs-tasks.amazonaws.com"
                    ]
                }
            }
        },
        {
            "Action": [
                "codecommit:CancelUploadArchive",
                "codecommit:GetBranch",
                "codecommit:GetCommit",
                "codecommit:GetUploadArchiveStatus",
                "codecommit:UploadArchive"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplication",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codestar-connections:UseConnection"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "rds:*",
                "ecs:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "lambda:InvokeFunction",
                "lambda:ListFunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "opsworks:CreateDeployment",
                "opsworks:DescribeApps",
                "opsworks:DescribeCommands",
                "opsworks:DescribeDeployments",
                "opsworks:DescribeInstances",
                "opsworks:DescribeStacks",
                "opsworks:UpdateApp",
                "opsworks:UpdateStack"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:DeleteStack",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "cloudformation:CreateChangeSet",
                "cloudformation:DeleteChangeSet",
                "cloudformation:DescribeChangeSet",
                "cloudformation:ExecuteChangeSet",
                "cloudformation:SetStackPolicy",
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild",
                "codebuild:BatchGetBuildBatches",
                "codebuild:StartBuildBatch"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Effect": "Allow",
            "Action": [
                "devicefarm:ListProjects",
                "devicefarm:ListDevicePools",
                "devicefarm:GetRun",
                "devicefarm:GetUpload",
                "devicefarm:CreateUpload",
                "devicefarm:ScheduleRun"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "servicecatalog:ListProvisioningArtifacts",
                "servicecatalog:CreateProvisioningArtifact",
                "servicecatalog:DescribeProvisioningArtifact",
                "servicecatalog:DeleteProvisioningArtifact",
                "servicecatalog:UpdateProduct"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudformation:ValidateTemplate"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:DescribeImages"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "states:DescribeExecution",
                "states:DescribeStateMachine",
                "states:StartExecution"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "appconfig:StartDeployment",
                "appconfig:StopDeployment",
                "appconfig:GetDeployment"
            ],
            "Resource": "*"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodePipelineServiceRole_bakery_attach" {
  role       = aws_iam_role.AWSCodePipelineServiceRole_bakery.name
  policy_arn = aws_iam_policy.AWSCodePipelineServiceRole_bakery_policy.arn
}


#CodeBuild base role / policy
resource "aws_iam_role" "AWSCodeBuild_base_bakery" {
  name = "${local.ClientName}-${var.EnvName}-${local.App}-codebuild-base-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.AccountNumber}:role/${local.ClientName}-${var.EnvName}-${local.App}-codebuild-full-service-role"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

#depends_on = [aws_iam_role.AWSCodeBuild_full_bakery]

}

resource "aws_iam_policy" "AWSCodeBuild_base_bakery_policy" {
  name = "${local.ClientName}-${var.EnvName}-${local.App}-codebuild-base-service-role-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:ca-central-1:${var.AccountNumber}:log-group:/aws/codebuild/${local.ClientName}-${var.EnvName}-${local.App}-codebuild-project",
                "arn:aws:logs:ca-central-1:${var.AccountNumber}:log-group:/aws/codebuild/${local.ClientName}-${var.EnvName}-${local.App}-codebuild-project:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-ca-central-1-*",
                "arn:aws:s3:::${local.ClientName}-${var.EnvName}-${local.App}-bucket/${local.ClientName}-${var.EnvName}-${local.App}/*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:ca-central-1:${var.AccountNumber}:report-group/${local.ClientName}-${var.EnvName}-${local.App}-codebuild-project-*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeBuild_base_bakery_attach" {
  role       = aws_iam_role.AWSCodeBuild_base_bakery.name
  policy_arn = aws_iam_policy.AWSCodeBuild_base_bakery_policy.arn
}


#CodeBuild Full Role / policy
resource "aws_iam_role" "AWSCodeBuild_full_bakery" {
  name = "${local.ClientName}-${var.EnvName}-${local.App}-codebuild-full-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.AccountNumber}:root"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.AccountNumber}:role/${local.ClientName}-${var.EnvName}-${local.App}-codebuild-base-service-role"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}  
EOF

#depends_on = [aws_iam_role.AWSCodeBuild_base_bakery]

}

resource "aws_iam_policy" "AWSCodeBuild_full_bakery_policy" {
  name = "${local.ClientName}-${var.EnvName}-${local.App}-codebuild-full-service-role-policy"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "application-autoscaling:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "s3:*",
                "logs:*",
                "iam:*",
                "cloudwatch:*",
                "kms:*",
                "ssm:*",
                "ec2:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeBuild_full_bakery_attach" {
  role       = aws_iam_role.AWSCodeBuild_full_bakery.name
  policy_arn = aws_iam_policy.AWSCodeBuild_full_bakery_policy.arn
}
