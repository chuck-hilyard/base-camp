#!/bin/bash
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. The script uses the
# run-consul script to configure and start Consul in client mode and then the run-vault script to configure and start
# Vault in server mode. Note that this script assumes it's running in an AMI built from the Packer template in
# examples/vault-consul-ami/vault-consul.json.

set -e

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# The Packer template puts the TLS certs in these file paths
readonly VAULT_TLS_CERT_FILE="/opt/vault/tls/vault.crt.pem"
readonly VAULT_TLS_KEY_FILE="/opt/vault/tls/vault.key.pem"

# The cluster_tag variables below are filled in via Terraform interpolation
/opt/consul/bin/run-consul --client --cluster-tag-key "${consul_cluster_tag_key}" --cluster-tag-value "${consul_cluster_tag_value}"
/opt/vault/bin/run-vault --tls-cert-file "$VAULT_TLS_CERT_FILE"  --tls-key-file "$VAULT_TLS_KEY_FILE"

# Initializes a vault server
# run-vault is running on the background and we have to wait for it to be done,
# so in case this fails we retry.
function retry_init {
  for i in $(seq 1 20); do
    echo "Initializing Vault agent..."
    # The boolean operations with the exit status are there to temporarily circumvent the "set -e" at the
    # beginning of this script which exits the script immediatelly for error status while not losing the exit status code
    server_output=$(/opt/vault/bin/vault operator init) && exit_status=0 || exit_status=$?
    if [[ $exit_status -eq 0 ]]; then
      return
    fi
    echo "Failed to auth initialize Vault. Will sleep for 5 seconds and try again."
    sleep 5
  done

  echo "Failed to initialize Vault."
  exit $exit_status
}

retry_init

# The expected output should be similar to this:
# ==========================================================================
# Unseal Key 1: ddPRelXzh9BdgqIDqQO9K0ldtHIBmY9AqsTohM6zCRl7
# Unseal Key 2: liSgypzdVrAxz73KbKyCMjVeSnRMuxCZMk1PWIZdjENS
# Unseal Key 3: pmgeVu/fs8+jl8bOzf3Cq56BFufm4o7Sxt2oaUcvt6Dp
# Unseal Key 4: i3W2xJEyUqUqcO1QSjTA+Ua0RUPxnNWM27AqaC8wW7Zh
# Unseal Key 5: vHsQtCRgfblPeFYw1hhCVbji0MoNUP8zyIWhLWs3PebS
#
# Initial Root Token: cb076fc1-cc1f-6766-795f-b3822ba1ac57
#
# Vault initialized with 5 key shares and a key threshold of 3. Please securely
# distribute the key shares printed above. When the Vault is re-sealed,
# restarted, or stopped, you must supply at least 3 of these keys to unseal it
# before it can start servicing requests.
#
# Vault does not store the generated master key. Without at least 3 key to
# reconstruct the master key, Vault will remain permanently sealed!
#
# It is possible to generate new unseal keys, provided you have a quorum of
# existing unseal keys shares. See "vault operator rekey" for more information.
# ==========================================================================

# Unseals the server with 3 keys from this output
# Please note that this is not how it should be done in production as it is not secure and and we are
# not storing any of the tokens, so in case it gets resealed, the tokens are lost and we wouldn't be able to unseal it again
# Ideally it should be auto unsealed https://www.vaultproject.io/docs/enterprise/auto-unseal/index.html
# For this quick example specifically, we are just running one vault server and unsealing it like this
# for simplicity as this example focuses on authentication and not on unsealing
echo "$server_output" | head -n 3 | awk '{ print $4; }' | xargs -l /opt/vault/bin/vault operator unseal

# Exports the client token environment variable necessary for running the following vault commands
export VAULT_TOKEN=$(echo "$server_output" | head -n 7 | tail -n 1 | awk '{ print $4; }')

# Enables AWS authentication
/opt/vault/bin/vault auth enable aws

# Creates a policy that allows writing and reading from an "example_" prefix at "secret" backend
/opt/vault/bin/vault policy write "example-policy" -<<EOF
path "secret/example_*" {
  capabilities = ["create", "read"]
}
EOF

# Creates an authentication role
# The role name & ami id are being passed by terraform
# This example uses the ami id as a criteria for whitelisting, but there are multiple
# other settings you can pick for EC2 metadata auth.
# Read more at: https://www.vaultproject.io/api/auth/aws/index.html#create-role
/opt/vault/bin/vault write \
  auth/aws/role/${example_role_name}\
  auth_type=ec2 \
  policies=example-policy \
  max_ttl=500h \
  bound_ami_id=${ami_id}

# Writes some secret, this secret is being written by terraform for test purposes
# Please note that normally we would never pass a secret this way
# This is just so we can verify that our example instance is authenticating correctly
/opt/vault/bin/vault write secret/example_gruntwork the_answer=${example_secret}
