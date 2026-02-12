variable "prefix" {
  type = string
}

variable "create_groups" {
  type    = bool
  default = false
}

variable "groups" {
  type    = list(string)
  default = []
}
