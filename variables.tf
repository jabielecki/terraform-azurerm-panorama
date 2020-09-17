variable "resource_group_name" {
  description = "The name of the resource group in which the resources will be created"
  type        = string
}

variable "location" {
  description = "The location/region where the virtual network is created. Changing this forces a new resource to be created."
  type        = string
}

variable "pan_publisher" {
  description = "Publish for Source image and Plan parameters"
  default     = "paloaltonetworks"
  type        = string
}

variable "pan_sku" {
  description = "License type - only BYOL is acceptable for Panorama at this point"
  type        = string
  default     = "byol"
}

variable "pan_series" {
  description = "Palo appliance type. This shoudl only be panoram"
  type        = string
  default     = "panorama"
}

variable "pan_version" {
  description = "IOS verstion to launch."
  type        = string
  default     = "latest"
}

# Track TF issue #19898 to define this as an object with optional parameters. 
variable "panoramas" {
  description = "Map of defined panoramas. Check example/basic/main.tf for an example. Also reference README.md"
  type        = map(any)
}
