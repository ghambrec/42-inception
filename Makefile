# variables
COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/$(USER)/data

all: up

secrets:
	@if [ ! -d secrets ]; then \
		mkdir -p secrets; \
		openssl rand -hex 16 > secrets/db_user_password.txt; \
		openssl rand -hex 16 > secrets/db_root_password.txt; \
		openssl rand -hex 16 > secrets/wp_admin_password.txt; \
		openssl rand -hex 16 > secrets/wp_user_password.txt; \
		openssl rand -hex 16 > secrets/ftp_user_password.txt; \
	fi

up: secrets
	mkdir -p $(DATA_DIR)/db
	mkdir -p $(DATA_DIR)/wordpress
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

stop:
	docker compose -f $(COMPOSE_FILE) stop

clean: down
	docker compose -f $(COMPOSE_FILE) down -v
	sudo rm -rf $(DATA_DIR)

fclean: clean
	docker system prune -af
	rm -rf secrets

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

re: fclean all

.PHONY: all secrets up down stop clean fclean logs re
