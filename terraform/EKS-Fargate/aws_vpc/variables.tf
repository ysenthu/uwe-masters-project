variable "vpc_cidr" {
  type = string
  description = "VPC cidr as a String"

}
variable "azs" {
  type = list(string)
  description = "Availability Zones to create subnets on"
}
variable "vpc_name" {
  type = string
  description = "VPC Name"
}

variable "pub_subnets_cidr" {
  type = list(string)
  description = "CIDR of the Public Subnets"
}