##  Azure Panorama Module
### Overview
This module is designed to provision Panoramas in Azure on exsisting resources. It has options for creating an Panorama with an addtional disk to support Panorama mode and Logger mode as required by the operator.

## Usage

Panorama Example

```hcl
module "panorama" {
  source              = "https://github.com/PaloAltoNetworks/terraform-azurerm-panorama?ref=v0.1.0"
  location            = var.location
  resource_group_name = azurerm_resource_group.test-rg.name
  panoramas = {
    panorama1 = {
      admin_username            = "fwadmin"
      ssh_key                   = var.ssh_key
      subnet_id                 = azurerm_subnet.test-subnet.id
      network_security_group_id = azurerm_network_security_group.test-nsg.id
    }
  }
}

```

Panorama Mode Example
```hcl
module "panorama" {
  source              = "https://github.com/PaloAltoNetworks/terraform-azurerm-panorama?ref=v0.1.0"
  location            = var.location
  resource_group_name = azurerm_resource_group.test-rg.name
  panoramas = {
    panorama1 = {
      admin_username            = "fwadmin"
      ssh_key                   = var.ssh_key
      pan_size                  = "Standard_DS5_v2" 
      subnet_id                 = azurerm_subnet.test-subnet.id
      network_security_group_id = azurerm_network_security_group.test-nsg.id
      logger_size = 2048
    }
  }
}
```

## Caveats
This module cannot target any  release of a PanOS. You will need to run the following command using Azure SDK to see what Panorama versions are currently supported.
`az vm image list -p paloaltonetworks -f panorama --all`

### Required Variables  
__Name:__ resource_group_name  
__TYPE:__  String  
__DESCRIPTION:__ Resoure group name for resources. i.e. test-rg   

__Name:__ Location  
__TYPE:__  String  
__DESCRIPTION:__ Location to create resources. i.e. West US  

__Name:__ panoramas  
__TYPE:__ Map  
__DESCRIPTION:__ This variable is used to defined your Panoramas. They key will be the name of the Panorama. __Note:__ This module currently only supports SSH key deployments.  
__REQUIRED KEYS:__   

| key | type | Description |
---|---|---
| subnet_id  | string  | Subnet ID of the Panorama interface. |
| network_security_group_id | string | NSG ID to attache to Panoram interface. | 
| admin_username | string | username for the VM |
| ssh_key | string | public ssh key to use for inital login |

__OPTIONAL KEYS:__    

| key | type | Description |
---|---|---
| disk_encryption_set_id | string  | Preview mode feature, may not work in all locations. |
| availability_set_id | string | Availability Set ID to put hte Panoramas into. | 
| storage_account_uri | string | Storaged account uri. This key enables boot diagnostics block. | 
| logger_size | integer | This key represents size of additional disk for deployment in Panorama mode or Logger mode. |  
| private_ip_address_allocation | string | This will assing the private ip address as either __STATIC__ or the default, __DYNAMIC__. if __STATIC__ is specified, please assign __private_ip_address__.
| private_ip_address | string | This will assign a static private IP for use. |
| public_ip_address_id | string | This will assign a public ip that was created. | 

### Optional Variables
__Name:__ pan_publisher  
__TYPE:__ string  
__DESCRIPTION:__ Name of the image publish, defaults to __paloaltonetworks__  
__Name:__ pan_series  
__TYPE:__ string  
__DESCRIPTION:__  Name of type of product or offer, defaults to __panorama__.  

__Name:__ pan_version  
__TYPE:__ string  
__DESCRIPTION:__  PanOS version to be deployed, defaults to __latest__  

__Name:__ pan_size  
__TYPE:__ string  
__DESCRIPTION:__ Size of Panorama to deploy, defaults to __Standard_DS3_v2__.  
