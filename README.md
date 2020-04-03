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

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| location | The location/region where the virtual network is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| pan\_publisher | Publish for Source image and Plan parameters | `string` | `"paloaltonetworks"` | no |
| pan\_series | Palo appliance type. This shoudl only be panoram | `string` | `"panorama"` | no |
| pan\_size | VM size to launch - at least Standard\_DS5\_v2 for Panorama mode | `string` | `"Standard_DS3_v2"` | no |
| pan\_sku | License type - only BYOL is acceptable for Panorama at this point | `string` | `"byol"` | no |
| pan\_version | IOS verstion to launch. | `string` | `"latest"` | no |
| panoramas | Map of defined panoramas. Check example/basic/main.tf for an example. Also reference README.md | `map(any)` | n/a | yes |
| resource\_group\_name | The name of the resource group in which the resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| panoramas | Information of Panorama's deployed to Azure. |
