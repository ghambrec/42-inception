# variables
COMPOSE_FILE = srcs/docker-compose.yml
DATA_DIR = /home/$(USER)/data

all: up

up:
	mkdir -p $(DATA_DIR)/db
	mkdir -p $(DATA_DIR)/wordpress
	docker compose -f $(COMPOSE_FILE) up -d --build

down:
	docker compose -f $(COMPOSE_FILE) down

clean: down
	docker compose -f $(COMPOSE_FILE) down -v
	sudo rm -rf $(DATA_DIR)

fclean: clean
	docker system prune -af

logs:
	docker compose -f $(COMPOSE_FILE) logs -f

re: fclean all

.PHONY: all setup up down clean fclean logs re
