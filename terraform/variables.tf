variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "eu-west-1"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "172.31.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "172.31.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "172.31.0.0/24"
}

variable "elasticsearch_private_ip" {
  description = "Private IP for elasticsearch"
  default     = "172.31.0.10"
}

variable "logstash_private_ip" {
  description = "Private IP for logstash"
  default     = "172.31.0.11"
}
