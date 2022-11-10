variable "region" {
  default = "us-east-2"
}

//variable "access_key" {
// type    = string
// default = ""
//}

//variable "secret_key" {
//type    = string
//default = ""
//}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
variable "ami" {
  type    = string
  default = ""
}


variable "private_subnet" {
  type    = string
  default = ""
}
variable "vpc_security_group_ids" {

}

variable "public_subnet" {
  type    = list(string)
  default = [""]
}
variable "key_name" {
  type = string
}
variable "tags" {
  type        = string
  description = "naming eg hns-PROJECT-APPLICATION-type"
  default     = "hns-PROJECT-APPLICATION-type"
}
variable "ssl_cert" {
  type    = string
  default = "test-insights_heidrickdigital_com"
}
variable "port" {
  default = 443
}
variable "agent_url" {
  type    = string
  default = "https://dev.azure.com/tazioonline"
}
variable "agent_token" {
  type    = string
  default = " "
}
variable "agent_pool" {
  type    = string
  default = "Heidrick Test Pool"
}
variable "agent_hostname" {
  type    = string
  default = "test-insights-websrv-1"
}

variable "name" {
  type    = string
  default = "test-insight"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0e99a5961a71f5a48"
}

variable "ec2_volume" {
  default = 30
}