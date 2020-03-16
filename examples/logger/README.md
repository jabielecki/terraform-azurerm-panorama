## Logger Panorama Creation

This example creates the following dependent resources:
  * Resource group
  * Vnet
  * Subnet
  * NSG

Then it creates two Panoramas in Panorama Mode with minimal configuration and optional parameters . These will not be reachable fromthe Internet as the proper security rules have not been applied. Also you would need to pass in a public IP field as defined in the module.
