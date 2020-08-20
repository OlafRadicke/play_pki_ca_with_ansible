resource "azurerm_virtual_network" "main" {
  name                             = "{{ azure_prefix }}-network"
  address_space                    = ["10.0.0.0/16"]
  location                         = azurerm_resource_group.main.location
  resource_group_name              = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                             = "internal"
  resource_group_name              = azurerm_resource_group.main.name
  virtual_network_name             = azurerm_virtual_network.main.name
  address_prefixes                 = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "{{ azure_prefix }}-sec-group" {
  name                             = "{{ azure_prefix }}-sec-group"
  location                         = azurerm_resource_group.main.location
  resource_group_name              = azurerm_resource_group.main.name
  tags = {
      environment                  = "test"
  }
}

resource "azurerm_network_security_rule" "{{ azure_prefix }}-sec-rule-ssh" {
  name                             = "{{ azure_prefix }}-sec-rule-ssh"
  priority                         = 101
  direction                        = "Inbound"
  access                           = "Allow"
  protocol                         = "*"
  source_port_range                = "*"
  destination_port_range           = "22"
  source_address_prefix            = "*"
  destination_address_prefix       = "*"

  resource_group_name              = azurerm_resource_group.main.name
  network_security_group_name      = azurerm_network_security_group.{{ azure_prefix }}-sec-group.name
}

resource "azurerm_network_security_rule" "{{ azure_prefix }}-sec-rule-http" {
  name                             = "{{ azure_prefix }}-sec-rule-http"
  priority                         = 1001
  direction                        = "Inbound"
  access                           = "Allow"
  protocol                         = "*"
  source_port_range                = "*"
  destination_port_range           = "{{ pki_csr_exchange_port }}"
  source_address_prefix            = "*"
  destination_address_prefix       = "*"

  resource_group_name              = azurerm_resource_group.main.name
  network_security_group_name      = azurerm_network_security_group.{{ azure_prefix }}-sec-group.name
}

resource "azurerm_network_security_rule" "{{ azure_prefix }}-sec-rule-outbound" {
  name                             = "{{ azure_prefix }}-sec-rule-outbound"
  priority                         = 1002
  direction                        = "Outbound"
  access                           = "Allow"
  protocol                         = "*"
  source_port_range                = "*"
  destination_port_range           = "*"
  source_address_prefix            = "*"
  destination_address_prefix       = "*"

  resource_group_name              = azurerm_resource_group.main.name
  network_security_group_name      = azurerm_network_security_group.{{ azure_prefix }}-sec-group.name
}

{% for item in azure_vm %}

###################  network configuration for {{ item.name }} ################

resource "azurerm_public_ip" "{{ azure_prefix }}-{{ item.name }}-ip" {
  name                             = "{{ azure_prefix }}-{{ item.name }}-ip"
  location                         = azurerm_resource_group.main.location
  resource_group_name              = azurerm_resource_group.main.name
  allocation_method                = "Dynamic"
  idle_timeout_in_minutes          = 30

  tags = {
    environment                    = "test"
  }
}

resource "azurerm_network_interface" "{{ azure_prefix }}-{{ item.name }}-nic" {
  name                             = "{{ azure_prefix }}-{{ item.name }}-nic"
  location                         = azurerm_resource_group.main.location
  resource_group_name              = azurerm_resource_group.main.name

  ip_configuration {
    name                           = "testconfiguration1"
    subnet_id                      = azurerm_subnet.internal.id
    private_ip_address_allocation  = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.{{ azure_prefix }}-{{ item.name }}-ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "{{ azure_prefix }}-{{ item.name }}-sec-link" {
    network_interface_id           = azurerm_network_interface.{{ azure_prefix }}-{{ item.name }}-nic.id
    network_security_group_id      = azurerm_network_security_group.{{ azure_prefix }}-sec-group.id
}

{% endfor %}
