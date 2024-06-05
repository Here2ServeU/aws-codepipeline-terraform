resource "aws_codecommit_repository" "t2s-demo" {
  repository_name = "t2s-demo"
  description     = "This is the demo repository for T2S"

    # Add lifecycle configuration to ignore changes to all attributes
  lifecycle {
    ignore_changes = all
  }
}
