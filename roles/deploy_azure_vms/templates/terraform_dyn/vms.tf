
{% for item in azure_vm %}

resource "azurerm_linux_virtual_machine" "{{ azure_prefix }}-{{ item.name }}" {
  name                   = "{{ azure_prefix }}-{{ item.name }}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  size                   = "{{ azure_vm_size }}"
  admin_username         = "{{ admin_username }}"
  network_interface_ids  = [azurerm_network_interface.{{ azure_prefix }}-{{ item.name }}-nic.id]

  admin_ssh_key {
    username             = "{{ admin_username }}"
    public_key           = file("{{ azure_ssh_public_key }}")
  }

  os_disk {
    name                 = "{{ azure_prefix }}-{{ item.name }}-disk1"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher            = "OpenLogic"
    offer                = "CentOS"
    sku                  = "7.5"
    version              = "latest"
  }
}
{% endfor %}