pwd := $(shell pwd)
package_path = ${pwd}/packages
access_management_path = ${pwd}/packages/access_management
registration_path = ${pwd}/packages/registration
frontend_path = ${pwd}/packages/frontend

infra:
	cp ${package_path}/docker/.env-example ${package_path}/.env
	cd ${package_path} && docker-compose up -d

access_management:
	cp ${access_management_path}/docker/.env-example ${access_management_path}/docker/.env
	cp ${access_management_path}/docker/keycloak/config.json.example ${access_management_path}/docker/keycloak/config.json
	cd ${access_management_path}/docker && docker-compose up -d

registration:
	cp ${registration_path}/docker/.env-example ${registration_path}/docker/.env
	cp ${registration_path}/config/database.yml.example ${registration_path}/config/database.yml
	cp ${registration_path}/.env.example ${registration_path}/.env
	cd ${registration_path}/docker && docker-compose up -d

frontend:
	cp ${frontend_path}/docker/.env-example ${frontend_path}/docker/.env
	cp ${frontend_path}/.env.example ${frontend_path}/.env
	cd ${frontend_path}/docker && docker-compose up -d