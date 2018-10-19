
provider "vault" {
  address = "https://10.233.136.141:8200"
  token   = "${var.vault_token}" 
}
