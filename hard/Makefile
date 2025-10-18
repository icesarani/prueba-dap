.PHONY: help start stop build test test-problem-1 test-problem-2 test-problem-3 clean reset logs init

help:
	@echo "Hard Level - Bug Fixing Evaluation System"
	@echo ""
	@echo "Available commands:"
	@echo "  make init          - Initialize the environment (start MongoDB)"
	@echo "  make start         - Start the application and MongoDB"
	@echo "  make stop          - Stop all services"
	@echo "  make build         - Build Docker images"
	@echo "  make test          - Run all tests"
	@echo "  make test-problem-1 - Run tests for problem 1"
	@echo "  make test-problem-2 - Run tests for problem 2"
	@echo "  make test-problem-3 - Run tests for problem 3"
	@echo "  make logs          - Show application logs"
	@echo "  make clean         - Stop services and remove results"
	@echo "  make reset         - Reset database and restart services"

init:
	@echo "Initializing Hard Level environment..."
	docker-compose up -d mongodb
	@echo "Waiting for MongoDB to be ready..."
	@sleep 5
	@echo "Environment ready!"

start:
	@echo "Starting Hard Level services..."
	docker-compose up -d
	@echo "Services started. Application available at http://localhost:3000"

stop:
	@echo "Stopping Hard Level services..."
	docker-compose down

build:
	@echo "Building Docker images..."
	docker-compose build

test:
	@echo "Running all tests..."
	docker-compose up -d mongodb
	@sleep 3
	docker-compose run --rm test npm test
	docker-compose down

test-problem-1:
	@echo "Running tests for Problem 1..."
	./evaluate.sh problem-1

test-problem-2:
	@echo "Running tests for Problem 2..."
	./evaluate.sh problem-2

test-problem-3:
	@echo "Running tests for Problem 3..."
	./evaluate.sh problem-3

logs:
	docker-compose logs -f app

clean:
	@echo "Cleaning up..."
	docker-compose down -v
	rm -rf results/*.json
	@echo "Cleanup complete!"

reset:
	@echo "Resetting environment..."
	docker-compose down -v
	docker-compose up -d mongodb
	@sleep 5
	@echo "Environment reset complete!"
