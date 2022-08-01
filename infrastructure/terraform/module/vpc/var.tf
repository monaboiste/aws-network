variable "vpc_name" {
  description = "(Optional) The name of the VPC"
  type        = string
  default     = "monaboiste-vpc"
}

variable "tags" {
  description = "(Optional) Additional tags"
  type        = map(string)
  default     = {}
}

variable "cidr_block" {
  description = "CIDR block"
  type        = string
}

variable "public_subnets_cidr_block" {
  description = "The public subnets CIDR block"
  type        = list(string)
}

variable "private_subnets_cidr_block" {
  description = "The private subnets CIDR block"
  type        = list(string)
}

variable "availability_zones" {
  description = "AZ in which all the resources will be deployed"
  type        = list(string)
}
