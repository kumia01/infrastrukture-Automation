variable "access_key" {
  default = "${secret("github_access_key")}"
}

variable "secret_key" {
  default = "${secret("github_secret_key")}"
}
