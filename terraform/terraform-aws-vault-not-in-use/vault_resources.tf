
variable "vault_token" { default = "" }

resource "vault_auth_backend" "ldap" {
  type = "ldap"
}

resource "vault_ldap_auth_backend" "ldap_backend" {
  path        = "ldap"
  url         = "ldap://10.10.255.14:389"
  userdn      = "ou=People,dc=reachlocal,dc=com"
  userattr    = "uid"
  groupdn     = "ou=Group,dc=reachlocal,dc=com"
  binddn      = "cn=PuppetMaster,dc=reachlocal,dc=com"
  bindpass    = "${var.bindpass}"
}
