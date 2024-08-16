# resource "aws_s3_bucket" "terraform-state" {
#   bucket        = var.bucket
#     versioning {
#         enabled = true
#     }
#   force_destroy = true
#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         kms_master_key_id = "arn"
#         sse_algorithm     = "aws:kms"
#       }
#     }
#   }
# }

# # To Test the TFSec, Comment any of the below or set to false it will trigger failure, Also you could cause a typo error to test with from your local, run 'tfsec .' (the do '.' shows your current directory) where you have your terraform files to scan; make sure you have tfsec installed
#   resource "aws_s3_bucket_public_access_block" "terraform-state" {
#     bucket = aws_s3_bucket.terraform-state.id
#     block_public_acls   = true 
#     block_public_policy = true
#     ignore_public_acls = true
#     restrict_public_buckets = true
# }

module "vpc" {
  source  = "./Modules/VPC"
  region = "us-east-1"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_count  = 2
  private_subnet_count = 2
  project_name         = "example-project"
  tags                 = {
    Environment = "dev",
    Project     = "Example"
  }
}
