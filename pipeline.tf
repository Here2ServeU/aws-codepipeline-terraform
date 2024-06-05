#
# codepipeline - demo
#
resource "aws_codepipeline" "t2s-demo" {
  name     = "demo-docker-pipeline"
  role_arn = aws_iam_role.t2s-codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.t2s-artifacts.bucket
    type     = "S3"
    encryption_key {
      id   = aws_kms_alias.t2s-artifacts.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["t2s-docker-source"]

      configuration = {
        RepositoryName = aws_codecommit_repository.t2s-demo.repository_name
        BranchName     = "master"
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
      input_artifacts  = ["t2s-docker-source"]
      output_artifacts = ["t2s-docker-build"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.t2s-demo.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "DeployToECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["t2s-docker-build"]
      version         = "1"

      configuration = {
        ApplicationName                = aws_codedeploy_app.t2s-demo.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.t2s-demo.deployment_group_name
        TaskDefinitionTemplateArtifact = "t2s-docker-build"
        AppSpecTemplateArtifact        = "t2s-docker-build"
      }
    }
  }
}


