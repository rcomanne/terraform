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

variable "resource_group" {
  description = "Resource group the network components should belong to"
}
