# Frontend

Frontend application developed in [vuejs](https://vuejs.org/) and [vuetifyjs](https://vuetifyjs.com/en/)

# Start

Copy file with environment variables

```bash
cp docker/.env-example docker/.env
```

```bash
cp .env.example .env
```

Run container

```bash
cd docker && docker-compose up -d --build && cd ..
```

# Commands

It is possible to use the container to execute commands in go and shell

Access container
```bash
docker exec -it -u dev frontend_app bash
```
