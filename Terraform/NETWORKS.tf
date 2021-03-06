#Azure vNet Module
resource "azurerm_resource_group" "rg" {
  name     = "${var.shared_resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${azurerm_resource_group.rg.name}-vnet"  
  location            = "${var.location}"
  address_space       = ["${var.address_space}"]
  resource_group_name = "${azurerm_resource_group.rg.name}"
  dns_servers         = ["${var.dns_servers}"]
}

resource "azurerm_subnet" "mgmt_subnet" {
  name                      = "${var.subnet_name_prefix}mgmt"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.mgmt_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_MGMT.id}"
}

resource "azurerm_subnet" "untrust_subnet" {
  name                      = "${var.subnet_name_prefix}untrust"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.untrust_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_UNTRUST.id}"
}

resource "azurerm_subnet" "trust_subnet" {
  name                      = "${var.subnet_name_prefix}trust"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.trust_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_TRUST.id}"
  route_table_id            = "${azurerm_route_table.trust_route_table.id}"
}

resource "azurerm_subnet" "dmz_subnet" {
  name                       = "${var.subnet_name_prefix}dmz"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.dmz_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_DMZ.id}"
  route_table_id            = "${azurerm_route_table.dmz_route_table.id}"
}

resource "azurerm_subnet" "appgw_subnet" {
  name                      = "${var.subnet_name_prefix}appgw"
  virtual_network_name      = "${azurerm_virtual_network.vnet.name}"
  resource_group_name       = "${azurerm_resource_group.rg.name}"
  address_prefix            = "${var.appgw_subnet}"
  network_security_group_id = "${azurerm_network_security_group.nsg_APPGW.id}"
}