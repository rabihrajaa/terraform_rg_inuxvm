
# RSA key of size 4096 bits
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# resource "local_file" "private_key" {
#   content         = tls_private_key.vm1.private_key_pem
#   filename        = pathexpand("~/.ssh/vm1")
#   file_permission = "0600"
# }

# resource "local_file" "public_key" {
#   content  = tls_private_key.vm1.public_key_openssh
#   filename = pathexpand("~/.ssh/vm1.pub")
# }

data "azurerm_key_vault" "main" {
  name                = "kv-devops-${var.env_name}-souir3"
  resource_group_name = "rg-devops-${var.env_name}"
}

resource "azurerm_key_vault_secret" "vm1_ssh_private" {
  name         = "vm1-ssh-private"
  value        = tls_private_key.vm1.private_key_pem
  key_vault_id = data.azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "vm1_ssh_public" {
  name         = "vm1-ssh-public"
  value        = tls_private_key.vm1.public_key_openssh
  key_vault_id = data.azurerm_key_vault.main.id
}
