COMPOSE = docker compose -f db/docker-compose.yml

.PHONY: db-up db-down db-ps db-psql

db-up:
	$(COMPOSE) up -d --build

db-down:
	$(COMPOSE) down

db-ps:
	$(COMPOSE) ps

db-psql:
	$(COMPOSE) exec db psql -U dbadmin -d eddy