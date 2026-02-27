variable "function_name" { type = string }
variable "role_arn" { type = string }
variable "source_dir" { type = string }

variable "queue_arn" { type = string }
variable "queue_url" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}

variable "batch_size" {
  type    = number
  default = 10
}