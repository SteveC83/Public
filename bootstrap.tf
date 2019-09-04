variable g-location {}
variable g-vmsize {}
variable g-core-kv {}
variable g-core-rg {}
variable g-environment {}
variable g-tenantid {}

data "azurerm_client_config" "current" {}

#data "azurerm_key_vault" "kv-dev-core" {
 # name                = "${var.g-core-kv}"
  #resource_group_name = "${var.g-core-rg}"
#}


#output "vault_uri" {
 # value = "${data.azurerm_key_vault.kv-dev-core.vault_uri}"
#}

resource "azurerm_resource_group" "rg-dev-core-mgmt" {
        name = "${var.g-core-rg}"
        location = "${var.g-location}"

        tags = {
            environment = "${var.g-environment}"
        }
}