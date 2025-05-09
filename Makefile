.PHONY: dev

PROJECT?=azeroth

dev:
	docker-compose run $(PROJECT) /bin/bash
