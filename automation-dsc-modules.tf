resource "azurerm_automation_account" "test" {
  name                  = "testDSCAccount"
  location              = "${var.g-location}"
  resource_group_name   = "${var.g-core-rg}"
  depends_on = ["azurerm_resource_group.rg-dev-core-mgmt"]

  sku_name = "Basic"

  tags = {
    environment = "test/dev"
  }
 }


resource "azurerm_automation_module" "computermanagement-dsc" {
  name                    = "ComputerManagementDsc"
  resource_group_name     = "${var.g-core-rg}"
  automation_account_name = "${azurerm_automation_account.test.name}"
  depends_on = ["azurerm_automation_account.test"]
  module_link  {
    uri = "https://www.powershellgallery.com/api/v2/package/ComputerManagementDsc/6.5.0.0"
  }
}

resource "azurerm_automation_module" "networking-dsc" {
  name                    = "NetworkingDsc"
  resource_group_name     = "${var.g-core-rg}"
  automation_account_name = "${azurerm_automation_account.test.name}"
  depends_on = ["azurerm_automation_account.test"]
  module_link  {
    uri = "https://www.powershellgallery.com/api/v2/package/NetworkingDsc/7.3.0.0"
  }
}

resource "azurerm_automation_module" "auditpolicy-dsc" {
  name                    = "AuditPolicyDsc"
  resource_group_name     = "${var.g-core-rg}"
  automation_account_name = "${azurerm_automation_account.test.name}"
  depends_on = ["azurerm_automation_account.test"]
  module_link  {
    uri = "https://www.powershellgallery.com/api/v2/package/AuditPolicyDsc/1.4.0.0"
  }
}

resource "azurerm_automation_module" "securitypolicy-dsc" {
  name                    = "SecurityPolicyDsc"
  resource_group_name     = "${var.g-core-rg}"
  automation_account_name = "${azurerm_automation_account.test.name}"
  depends_on = ["azurerm_automation_account.test"]
  module_link  {
    uri = "https://www.powershellgallery.com/api/v2/package/SecurityPolicyDsc/2.9.0.0"
  }
}
resource "azurerm_automation_module" "Chocolatey-dsc" {
  name                    = "cChoco"
  resource_group_name     = "${var.g-core-rg}"
  automation_account_name = "${azurerm_automation_account.test.name}"
  depends_on = ["azurerm_automation_account.test"]
  module_link  {
    uri = "https://www.powershellgallery.com/api/v2/package/cChoco/2.4.0.0"
  }
}
resource "azurerm_automation_module" "Storagedsc" {
  name                    = "StorageDSC"
  resource_group_name     = "${var.g-core-rg}"
  automation_account_name = "${azurerm_automation_account.test.name}"
  depends_on = ["azurerm_automation_account.test"]
  module_link  {
    uri = "https://www.powershellgallery.com/api/v2/package/StorageDSC/4.8.0.0"
  }
}
resource "azurerm_automation_dsc_configuration" "GlobalDscConfig" {
  name                    = "GlobalDscConfig"
  resource_group_name     = "${var.g-core-rg}"
  automation_account_name = "${azurerm_automation_account.test.name}"
  location                = "${var.g-location}"
  content_embedded        = "${file("./GlobalDscConfig.ps1")}"
} 
resource "azurerm_automation_dsc_nodeconfiguration" "GlobalDscConfig" {
  name                    = "GlobalDscConfig.localhost"
  resource_group_name     = "${var.g-core-rg}"
  automation_account_name = "${azurerm_automation_account.test.name}"
  depends_on              = ["azurerm_automation_dsc_configuration.GlobalDscConfig"]
  content_embedded        = "${file("${path.cwd}/GlobalDscConfig/localhost.mof")}"
}