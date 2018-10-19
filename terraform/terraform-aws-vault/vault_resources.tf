
resource "vault_auth_backend" "ldap" {
  type = "ldap"
}

resource "vault_ldap_auth_backend" "ldap_backend" {
  path        = "${vault_auth_backend.ldap.path}"
  url         = "ldap://auth.wh.reachlocal.com"
  userdn      = "OU=People,DC=reachlocal,DC=com"
  userattr    = "sAMAccountName"
  upndomain   = "EXAMPLE.ORG"
  discoverdn  = false
  groupdn     = "OU=Group,DC=reachlocal,DC=com"
  groupfilter = "(cn=eng)"
}
