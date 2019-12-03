variable "subscription_id" {
  description = "The ID of the subscription to use"
  type        = string
}

variable "location" {
  description = "The short name for location/region where the resource is created"
  type        = string
  default = "we"
}

variable "location_full" {
  description = "The full name for location/region where the resource is"
  type        = string
  default = "westeurope"
}

variable "environment" {
  description = "environment used as a prefix but also to look up environemnt specific values. Possible values: dev, prod"
  type        = string
  default = "dev"
}
