resource "aws_ecr_repository" "t2s-demo" {
  name = "t2s-demo"

# Add lifecycle configuration to ignore changes to all attributes
  lifecycle {
    ignore_changes = all
  }
}

