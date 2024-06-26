
variable "project_id" {
  type        = string
  description = "Project id where the zone will be created."
  default     = ""
}

variable "name" {
  type        = string
  description = "DNS zone name."
  default     = "foo-local"
}

variable "domain" {
  type        = string
  description = "Zone domain."
  default     = "foo.local."
}
