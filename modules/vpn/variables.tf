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

variable "subnet_id" {
  description = "Full resource ID of the subnet we want to connect the NIC to"
  type = string
}

variable "nsg_id" {
  description = "Full resource ID of the NSG we want to be a part of"
  type = string
}

variable "resource_name" {
  description = "Name/type of the resource we are creating, this will be used for creating all components"
  type = string
}

variable "resource_group" {
  description = "Resource group the network components should belong to"
}

variable "vm_size" {
  description = "Size of the VM to create"
  type        = string
  default     = "Standard_B1s"
}

variable "vm_count" {
  description = "Total number of VM/resources to create"
  type = number
  default = 1
}
