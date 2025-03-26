BUILD_ENV ?= dev

COMPOSE_TEMPLATE_FILE := docker-compose.template.yaml
COMPOSE_OVERRIDE_FILE := docker-compose.$(BUILD_ENV).yaml
COMPOSE_FLAGS := -f docker-compose.yaml -f $(COMPOSE_OVERRIDE_FILE)
COMPOSE := docker compose $(COMPOSE_FLAGS)

# Ensure COMPOSE_OVERRIDE_FILE exists if it is included in COMPOSE_FLAGS
COMPOSE_TARGETS := $(word 2,$(findstring $(strip -f $(COMPOSE_OVERRIDE_FILE)),$(strip $(COMPOSE_FLAGS))))
$(COMPOSE_OVERRIDE_FILE):
	cp $(COMPOSE_TEMPLATE_FILE) $(COMPOSE_OVERRIDE_FILE)

.PHONY: build
build: $(COMPOSE_TARGETS)
	$(COMPOSE) build

.PHONY: up
up: build
	$(COMPOSE) up --detach

.PHONY: down
down: $(COMPOSE_TARGETS)
	$(COMPOSE) down --remove-orphans

.PHONY: clean
clean: $(COMPOSE_TARGETS)
	$(COMPOSE) down --remove-orphans --volumes
	rm -rf dist
	rm -rf node_modules

.PHONY: status
status: $(COMPOSE_TARGETS)
	$(COMPOSE) ps --all

.PHONY: shell
shell: up
	$(COMPOSE) exec web bash

.PHONY: bootstrap
bootstrap: up
	$(COMPOSE) exec web scripts/bootstrap

.PHONY: update
update: up
	$(COMPOSE) exec web scripts/update

.PHONY: setup
setup: up
	$(COMPOSE) exec web scripts/setup

.PHONY: test
test: up
	$(COMPOSE) exec web scripts/test

.PHONY: cibuild
cibuild: up
	$(COMPOSE) exec web scripts/cibuild
