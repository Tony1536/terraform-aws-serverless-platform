variable "name" {
  type = string
}
variable "hash_key" {
  type    = string
  default = "pk"
}
variable "tags" {
  type    = map(string)
  default = {}
}