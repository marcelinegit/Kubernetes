variable "public_key" {

  description = "public key used to keypair"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPBpUKy/l8nMzsZ3Sb/isrZYwBwjP+fxEtq0mdCOUSL ngahm@LAPTOP-KGP6P3EU"

}
variable "ami" {
  description = "the ami of the instance"
  type        = string
  default     = "ami-0ddc798b3f1a5117e"
}

variable "instance_type" {
  description = "the instance type"
  type        = string
  default     = "t2.medium"
}

