#!/bin/bash

_DB_URL="postgresql://$DB_USER:$DB_PASSWORD@$DB_HOST:5432/$DB_NAME?sslmode=disable"

function migrate:create {
    migrate create -ext sql -dir /app/db/migrations -seq $1 
}

function migrate:up {
    migrate -path /app/db/migrations -database $_DB_URL -verbose up
}

function migrate:down {
    migrate -path /app/db/migrations -database $_DB_URL -verbose down
}

function migrate:run {
    migrate -path /app/db/migrations -database $_DB_URL $1 $2 $3 $4 $5 $6
}