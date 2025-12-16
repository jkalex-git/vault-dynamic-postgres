## How to run

1. Run the docker compose file  ` docker compose up`
2. Run the vault config `./vault.sh`
3. Copy the `role_id` and `secret` from the above step to application.properties

Eg:
```
Key        Value
---        -----
role_id    caa463d6-a17f-e0e3-131a-08e503d80cc8
Key                   Value
---                   -----
secret_id             40c6149d-1ffd-9388-34d6-879f238381c3
secret_id_accessor    755a4ffe-9a68-0ce3-2aef-b90af91e07ea
secret_id_num_uses    0
secret_id_ttl         0s
```
```
quarkus.vault.authentication.app-role.role-id=caa463d6-a17f-e0e3-131a-08e503d80cc8
quarkus.vault.authentication.app-role.secret-id=40c6149d-1ffd-9388-34d6-879f238381c3
```
4. Start the quarkus app with Java 21
5. Run the main class in org.acme.quickstart.GreetingResourceIT inside `test` folder
6. Keep it running for more than 6 mins as it is the configured vault token TTL.
