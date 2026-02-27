variable "name_main" {
  type = string
}
variable "name_dlq" {
  type = string
}
variable "max_receive_count" {
  type    = number
  default = 5
}
variable "visibility_timeout_seconds" {
  type    = number
  default = 30
}
variable "message_retention_seconds" {
  type    = number
  default = 345600
}
variable "tags" {
  type    = map(string)
  default = {}
}