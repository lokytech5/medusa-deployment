# resource "aws_ecr_repository" "medusa_app_repository" {
#   name                 = "medusa-app"
#   image_tag_mutability = "MUTABLE"
#   force_delete         = true

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = {
#     Name = "medusa-app-repository"
#   }
# }

data "aws_ecr_repository" "medusa_app_repository" {
  name = "medusa-app"
}
