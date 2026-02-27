variable "name_prefix" { type = string }

variable "table_arn" { type = string }

variable "queue_arn" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}
