.PHONY: help start stop init test test-problem-1 test-problem-2 test-problem-3 clean reset build

help:
	@echo "SQL Practice Platform - Available Commands:"
	@echo ""
	@echo "  make start          - Start SQL Server container"
	@echo "  make stop           - Stop SQL Server container"
	@echo "  make init           - Initialize database with sample data"
	@echo "  make build          - Build test runner Docker image"
	@echo "  make test           - Run all tests (via Docker, no local .NET needed)"
	@echo "  make test-problem-1 - Run tests for problem 1 only"
	@echo "  make test-problem-2 - Run tests for problem 2 only"
	@echo "  make test-problem-3 - Run tests for problem 3 only"
	@echo "  make reset          - Reset database (remove all data and restart)"
	@echo "  make clean          - Remove results and stop containers"
	@echo ""

start:
	@echo "Starting SQL Server..."
	docker-compose up -d
	@echo "Waiting for SQL Server to be ready..."
	@sleep 15
	@echo "SQL Server is ready!"

stop:
	@echo "Stopping SQL Server..."
	docker-compose down

init: start
	@echo "Initializing database..."
	docker exec sql-practice-db /opt/mssql-tools18/bin/sqlcmd \
		-S localhost -U sa -P "YourStrong@Passw0rd" \
		-i /scripts/init-db.sql -C
	@echo "Database initialized successfully!"

build:
	@echo "Building test runner Docker image..."
	docker-compose build testrunner
	@echo "Test runner image built successfully!"

test:
	@echo "Running all tests via Docker..."
	docker-compose --profile test run --rm testrunner

test-problem-1:
	@echo "Running tests for problem 1..."
	@if [ ! -f users/problem-1_*.sql ]; then \
		echo "❌ No solution file found for problem 1"; \
		echo "Expected format: users/problem-1_<email>.sql"; \
		exit 1; \
	fi
	docker-compose --profile test run --rm testrunner

test-problem-2:
	@echo "Running tests for problem 2..."
	@if [ ! -f users/problem-2_*.sql ]; then \
		echo "❌ No solution file found for problem 2"; \
		echo "Expected format: users/problem-2_<email>.sql"; \
		exit 1; \
	fi
	docker-compose --profile test run --rm testrunner

test-problem-3:
	@echo "Running tests for problem 3..."
	@if [ ! -f users/problem-3_*.sql ]; then \
		echo "❌ No solution file found for problem 3"; \
		echo "Expected format: users/problem-3_<email>.sql"; \
		exit 1; \
	fi
	docker-compose --profile test run --rm testrunner

reset:
	@echo "Resetting database..."
	docker-compose down -v
	@$(MAKE) init

clean:
	@echo "Cleaning up..."
	rm -rf results/*.json
	docker-compose down
	@echo "Cleanup complete!"
