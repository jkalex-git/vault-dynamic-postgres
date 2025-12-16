#!/bin/sh

set -e

cat <<EOF | docker exec --interactive vault-quickstart-vault-1 sh

set -e

if ! vault secrets list | grep "database/"; then
 vault secrets enable database
 vault auth enable approle
fi

vault write database/config/postgres-gift \
    plugin_name=postgresql-database-plugin \
    allowed_roles="postgres-gift-default, postgres-gift-special" \
    connection_url="postgresql://{{username}}:{{password}}@postgres:5432/gift?sslmode=disable" \
    username="vault-gift" \
    password="initPassword"

vault write database/roles/postgres-gift-default \
    db_name=postgres-gift \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' \
        VALID UNTIL '{{expiration}}'; \
        GRANT gift to \"{{name}}\"; \
        GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\"; \
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public to \"{{name}}\";" \
    default_ttl=3m \
    max_ttl=21m \
    revocation_statements="
    ALTER ROLE \"{{name}}\" NOLOGIN; \
    REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM \"{{name}}\"; \
    REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM \"{{name}}\"; \
    DROP ROLE IF EXISTS \"{{name}}\"; \
    "
    renew_statements="ALTER ROLE \"{{name}}\" VALID UNTIL '{{expiration}}';"

vault write database/roles/postgres-gift-special \
    db_name=postgres-gift \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' \
        VALID UNTIL '{{expiration}}'; \
        GRANT gift to \"{{name}}\"; \
        GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\"; \
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public to \"{{name}}\";" \
    default_ttl=3m \
    max_ttl=21m \
    revocation_statements="
    ALTER ROLE \"{{name}}\" NOLOGIN; \
    REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM \"{{name}}\"; \
    REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM \"{{name}}\"; \
    DROP ROLE IF EXISTS \"{{name}}\"; \
    "
    renew_statements="ALTER ROLE \"{{name}}\" VALID UNTIL '{{expiration}}';"


# -----------------------------
# Add Vault policy for AppRole
cat <<POLICY_EOF > /tmp/postgres-database.hcl
path "database/creds/postgres-gift-special" {
  capabilities = ["read"]
}
path "database/creds/postgres-gift-default" {
  capabilities = ["read"]
}
POLICY_EOF

vault policy write postgres-database /tmp/postgres-database.hcl

# Attach policy to AppRole with 1m token TTL
vault write auth/approle/role/myapprole \
    token_policies="default,vault-quickstart-policy,postgres-database" \
    token_ttl=6m \
    token_max_ttl=60m

vault read auth/approle/role/myapprole/role-id
vault write -f auth/approle/role/myapprole/secret-id

EOF