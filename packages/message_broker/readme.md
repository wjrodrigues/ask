# Message brocker

Responsible for the messaging structure

# Dependency

- [rabbitmq](https://www.rabbitmq.com/)

# Start

Copy file with environment variables

```bash
cp .env.example .env
```

Copy file with realm settings

Run container
```bash
docker-compose up -d
```

# Manager

**Host:** http://localhost:15672/#/  
**User:** rabbitmq  
**Password:** rabbitmq  