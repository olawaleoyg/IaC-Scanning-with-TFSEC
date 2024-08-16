provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS Region"
  type        = string
}
