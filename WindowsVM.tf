resource "azurerm_virtual_machine" "main" {
  name                  = "test-vm"
  location              = "${var.g-location}"
  resource_group_name   = "${var.g-core-rg}"
  network_interface_ids = ["${azurerm_network_interface.main.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "Latest"    
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  
  os_profile_windows_config {
    provision_vm_agent = true
  }

  tags = {
    environment = "Test"
  }
}

resource "azurerm_managed_disk" "test" {
  name                 = "${var.nameprefix}-${count.index}-disk1"
  count                = "${(var.add-data-disk == true) ? var.diskcount : 0}"
  location              = "${var.g-location}"
  resource_group_name   = "${var.g-core-rg}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "${var.data-disk-size}"
}

resource "azurerm_virtual_machine_data_disk_attachment" "test" {
  count              = "${(var.add-data-disk == true) ? var.diskcount : 0}"
  managed_disk_id    = "${element(azurerm_managed_disk.test.*.id, count.index)}"
  virtual_machine_id = "${azurerm_virtual_machine.main.id}"  
  lun                = "1"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine_extension" "cse-dscconfig" {
  name                    = "test-dscconfig-cse"
  location              = "${var.g-location}"
  resource_group_name   = "${var.g-core-rg}"
  virtual_machine_name    = "${azurerm_virtual_machine.main.name}"
  publisher               = "Microsoft.Powershell"
  type                    = "DSC"
  type_handler_version    = "2.76"
  depends_on              = ["azurerm_virtual_machine.main"]

  settings = <<SETTINGS
        {
          "configurationArguments": {
              "RegistrationUrl": "${azurerm_automation_account.test.dsc_server_endpoint}",
              "NodeConfigurationName": "GlobalDscConfig.localhost"
          }
        }
        SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
        {
                "configurationArguments": {
                  "registrationKey": {
                    "userName": "NOT_USED",
                    "Password": "${azurerm_automation_account.test.dsc_primary_access_key}"
                  }
                }
        }
        PROTECTED_SETTINGS
}