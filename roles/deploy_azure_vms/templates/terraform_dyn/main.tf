
resource "azurerm_resource_group" "main" {
  name                   = "{{ azure_prefix }}"
  location               = "{{ azure_location }}"
}


