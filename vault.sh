#!/bin/sh

set -e

cat <<EOF | docker exec --interactive vault-quickstart-vault-1 sh

set -e

if ! vault secrets list | grep "database/"; then
 vault secrets enable database
fi

vault write database/config/postgres-gift \
    plugin_name=postgresql-database-plugin \
    allowed_roles="postgres-gift" \
    connection_url="postgresql://{{username}}:{{password}}@postgres:5432/gift?sslmode=disable" \
    username="vault-gift" \
    password="initPassword"

vault write database/roles/postgres-gift \
    db_name=postgres-gift \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' \
        VALID UNTIL '{{expiration}}'; \
        GRANT gift to \"{{name}}\"; \
        GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\"; \
        GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public to \"{{name}}\";" \
    default_ttl=2m  \
    max_ttl=1h \
    revocation_statements="REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM \"{{name}}\"; \
        REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM \"{{name}}\"; \
        REVOKE ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public FROM \"{{name}}\"; \
        ALTER DEFAULT PRIVILEGES FOR USER gift IN SCHEMA public REVOKE ALL ON TABLES FROM \"{{name}}\"; \
        ALTER DEFAULT PRIVILEGES FOR USER gift IN SCHEMA public REVOKE ALL ON SEQUENCES FROM \"{{name}}\"; \
        ALTER DEFAULT PRIVILEGES FOR USER gift IN SCHEMA public REVOKE ALL ON FUNCTIONS FROM \"{{name}}\"; \
        REVOKE CONNECT ON DATABASE gift FROM \"{{name}}\"; \
        DROP USER \"{{name}}\";"

EOF