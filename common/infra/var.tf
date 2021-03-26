variable "tags" {
  type = map(string)
  default = {
    microservice = "common"
  }
}

variable "suffix" {
  type    = string
  default = "20210326102834"
}
