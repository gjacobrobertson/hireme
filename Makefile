.PHONY: build
build:
	docker compose build

.PHONY: up
up: build
	docker compose up --detach

.PHONY: down
down:
	docker compose down --remove-orphans

.PHONY: clean
clean:
	docker compose down --remove-orphans --volumes
	rm -rf dist
	rm -rf node_modules

.PHONY: status
status:
	docker compose ps --all

.PHONY: shell
shell: up
	docker compose exec web bash

.PHONY: bootstrap
bootstrap: up
	docker compose exec web scripts/bootstrap

.PHONY: update
update: up
	docker compose exec web scripts/update

.PHONY: setup
setup: up
	docker compose exec web scripts/setup

.PHONY: test
test: up
	docker compose exec web scripts/test

.PHONY: cibuild
cibuild: up
	docker compose exec web scripts/cibuild