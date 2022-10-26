# Access management

Responsible for controlling the authorizations of clients and users who can access the services.

# Dependency

- [Keycloack](https://www.keycloak.org/)

# Start

Copy file with environment variables

```bash
cp docker/.env-example docker/.env
```

Copy file with realm settings

```bash
cp docker/keycloak/config.json.example docker/keycloak/config.json
```

Run container
```bash
docker-compose -f docker/docker-compose.yml up -d
```

# Access

**host**: http://localhost:8080/admin/  
**user**: keycloak-admin  
**password**: keycloak-admin  
