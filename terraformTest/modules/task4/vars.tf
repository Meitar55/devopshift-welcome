
variable "min_size" {
  description = "minimum amount of instances in autoscaling group"
  default     = 1
}

variable "max_size" {
  description = "maximum amount of instances in autoscaling group"
  default     = 3
}

variable "target_group_name" {
  description = "Name for the target group"
  default     = "meitar-target-group"
}

variable "instance_type" {
  type=string
  default = "t2.micro"
}

variable "subnet_id" {
    type=list(string)//it could be multiple
    default = []
}
variable "vpc"{//vpc id
  default = ""
}