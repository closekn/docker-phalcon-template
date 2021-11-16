.PHONY: up
up:
	docker compose up -d

.PHONY: build
build:
	docker compose build --no-cache --force-rm

.PHONY: stop
stop:
	docker compose stop

.PHONY: down
down:
	docker compose down --remove-orphans

.PHONY: restart
restart:
	@make down
	@make up

.PHONY: destroy
destroy:
	docker compose down --rmi all --volumes --remove-orphans

.PHONY: destroy-volumes
destroy-volumes:
	docker compose down --volumes --remove-orphans

.PHONY: ps
ps:
	docker compose ps
