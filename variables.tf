variable "project" {
  default     = "teraform-start"
}
variable "credentials_file" { 
  default     = "./.ssh/teraform-start-8d9cc76eff88.json"
}

variable "public_key_path" {
  description = "Path to the ssh public key of user TERR"
  default     = "./.ssh/terr_pub"
}

variable "private_key_path" {
  description = "Path to the ssh private key of user TERR"
  default     = "./.ssh/terr_priv"
}
