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
  default = "registry20210324165333/reception-func:latest"
}
