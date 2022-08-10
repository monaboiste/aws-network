variable "backend_state_name" {
  description = "The name for backend state. Must be unique across entire AWS"
  type        = string
}

variable "tags" {
  description = "(Optional) Additional tags"
  type        = map(string)
  default     = {}
}
