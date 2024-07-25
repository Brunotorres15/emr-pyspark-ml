variable "release_label" {
  default = "emr-7.0.0"
}
variable "log_uri_bucket" {
  default = "emr-log-<bucket-id>"
}

variable "files_bucket" {
  default = "./pipelines"
}

variable "files_data" {
  type = string
}

variable "files_bash" {
  type = string
}

variable "name_bucket" {
   type = string
}

variable "versioning_bucket" {
   type = string
}

variable "name_emr" {
   type = string
}