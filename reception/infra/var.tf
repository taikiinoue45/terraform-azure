variable "tags" {
  type = map(string)
  default = {
    microservice = "reception"
  }
}

variable "prefix" {
  type    = string
  default = "reception"
}

variable "docker_image" {
  type    = string
  default = "reception-func:latest"
}
