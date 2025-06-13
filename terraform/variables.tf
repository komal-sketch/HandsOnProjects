variable "PROJECT_K" {
  default = "devops-pipeline"
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  description = "Name of the AWS key pair"
}

variable "public_key_path" {
  description = "Path to local public key"
}



