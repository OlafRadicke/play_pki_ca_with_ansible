
provider "azurerm" {
  version           = "=2.20.0"
  features          {}
}

provider "azuread" {
    version         = "=0.4.0"
    subscription_id = "{{ secret_subscription_id }}"
    tenant_id       = "{{ secret_tenant_id }}"
}


# Um dan Status in der Azure-Cloud abzulegen
# terraform {
#     backend "azurerm" {}
# }
