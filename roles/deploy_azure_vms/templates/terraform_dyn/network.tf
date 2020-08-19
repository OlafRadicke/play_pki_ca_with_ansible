resource "azurerm_virtual_network" "main" {
  name                            = "{{ azure_prefix }}network"
  address_space                   = ["10.0.0.0/16"]
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                            = "internal"
  resource_group_name             = azurerm_resource_group.main.name
  virtual_network_name            = azurerm_virtual_network.main.name
  address_prefixes                = ["10.0.2.0/24"]
}

{% for item in azure_vm %}

resource "azurerm_public_ip" "{{ azure_prefix }}-{{ item.name }}-ip" {
  name                           = "{{ azure_prefix }}-{{ item.name }}-ip"
  location                       = azurerm_resource_group.main.location
  resource_group_name            = azurerm_resource_group.main.name
  allocation_method              = "Dynamic"
  idle_timeout_in_minutes        = 30

  tags = {
    environment                  = "test"
  }
}

resource "azurerm_network_interface" "{{ azure_prefix }}-{{ item.name }}" {
  name                            = "{{ azure_prefix }}-{{ item.name }}nic"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.{{ azure_prefix }}-{{ item.name }}-ip.id
  }
}
{% endfor %}


# resource "azurerm_public_ip" "example" {
#   name                    = "test-pip"
#   location                = azurerm_resource_group.example.location
#   resource_group_name     = azurerm_resource_group.example.name
#   allocation_method       = "Dynamic"
#   idle_timeout_in_minutes = 30

#   tags = {
#     environment = "test"
#   }
# }

# resource "azurerm_network_interface" "example" {
#   name                = "test-nic"
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   ip_configuration {
#     name                          = "testconfiguration1"
#     subnet_id                     = azurerm_subnet.example.id
#     private_ip_address_allocation = "Static"
#     private_ip_address            = "10.0.2.5"
#     public_ip_address_id          = azurerm_public_ip.example.id
#   }
# }