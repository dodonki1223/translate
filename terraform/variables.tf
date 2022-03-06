# Standard Variables
variable "aws_region" {
  description = "Target AWS Region"
  type        = string
  default     = "ap-northeast-1"
}

variable "aws_profile" {
  description = "Local AWS Profile Name"
  type        = string
  default     = "terraform"
}

variable "account_id" {
  description = "AWS account id"
  type        = string
  default     = "300367504550"
}

variable "application" {
  description = "Application Name"
  type        = string
  default     = "translate"
}
