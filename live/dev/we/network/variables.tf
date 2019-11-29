variable "subscription_id" {
  description = "The ID of the subscription to use"
  type = string
}

variable "location" {
  description = "The short name for location/region where the resource is created"
  type        = string
}

variable "location_full" {
  description = "The full name for location/region where the resource is"
  type        = string
}

variable "environment" {
  description = "environment used as a prefix but also to look up environemnt specific values. Possible values: dev, prod"
  type        = string
}
