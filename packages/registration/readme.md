# Registration

Service responsible for user registrations.

# Start

Copy file with environment variables

```bash
cp docker/.env-example docker/.env
```

Run container

```bash
docker-compose -f docker/docker-compose.yml up -d --build
```

# Commands

It is possible to use the container to execute commands in go and shell

Access container
```bash
docker exec -it -u dev registration_app bash
```

## Migrations

[Database migrations documentation](https://github.com/golang-migrate/migrate/tree/master/database/postgres)

> Inside the container

Create migrate
```bash
migrate:create MIGRATE_NAME
```

Perform migrations
```bash
migrate:up
```

Revert migrations
```bash
migrate:down
```

Execution with any argument
```bash
migrate:run version
```