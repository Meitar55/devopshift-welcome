variable "region" {
  default = "us-east-1"
}
variable "az1" {
  default = "us-east-1a"
}
variable "az2" {
  default = "us-east-1b"
}
variable "myName" {
  type = string
  default = "meitar"
}
variable "cidrBlockRange"{
  default = 16
}
/*
variable "cidrBlock"{
  default = "10.0.0.0/${var.cidrBlockRange}"
}
*/
variable "countPublicSubnets"{
    type=number
    default = 2
}

variable "countPrivateSubnets"{
    type=number
    default = 2
}

variable "availability_zones" {
  description = "List of availability zones in the region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}