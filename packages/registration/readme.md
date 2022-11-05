# Registration

Service responsible for user registrations.

# Start

Copy file with environment variables

```bash
cp docker/.env-example docker/.env
```

```bash
cp .env.example .env
```

```bash
cp config/database.yml.example config/database.yml
```

Run container

```bash
cd docker && docker-compose up -d --build && cd ..
```

# Commands

It is possible to use the container to execute commands in go and shell

Access container
```bash
docker exec -it -u dev registration_app bash
```

# Prepare application
Database

```bash
docker exec -u dev registration_app bash -c "rake db:drop db:setup db:seed"
```

#