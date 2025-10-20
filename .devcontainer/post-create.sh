#!/bin/bash
set -e

echo "🚀 Setting up DAP-ORT evaluation environment..."

# Install required tools
echo "📦 Installing tools..."
sudo apt-get update -qq
sudo apt-get install -y make curl postgresql-client netcat-openbsd &> /dev/null
echo "✓ Tools installed"

# Wait for PostgreSQL to be healthy
echo "⏳ Waiting for PostgreSQL..."
for i in {1..30}; do
    if pg_isready -h postgres -p 5432 -U postgres &> /dev/null; then
        echo "✓ PostgreSQL is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "⚠ PostgreSQL did not start in time"
    fi
    sleep 2
done

# PostgreSQL initializes automatically via docker-entrypoint-initdb.d
echo "✓ PostgreSQL database initialized automatically"

# Wait for MongoDB to be healthy
echo "⏳ Waiting for MongoDB..."
sleep 3  # Give MongoDB a moment to fully start
for i in {1..20}; do
    if nc -z mongodb 27017 &> /dev/null; then
        echo "✓ MongoDB is ready"
        break
    fi
    if [ $i -eq 20 ]; then
        echo "⚠ MongoDB did not start in time (not critical, will be available soon)"
    fi
    sleep 1
done

# Install Node.js dependencies for easy level
if [ -f "/workspace/easy/package.json" ]; then
    echo "📦 Installing easy level dependencies..."
    cd /workspace/easy && npm install --silent &> /dev/null
    echo "✓ Easy dependencies installed"
fi

# Build easy level evaluator Docker image
echo "🔨 Building easy level evaluator..."
cd /workspace/easy && docker compose build evaluator &> /dev/null
echo "✓ Easy evaluator built"

# Install Node.js dependencies for hard level
if [ -f "/workspace/hard/app/package.json" ]; then
    echo "📦 Installing hard level dependencies..."
    cd /workspace/hard/app && npm install --silent &> /dev/null
    echo "✓ Hard dependencies installed"
fi

# Build medium level test runner (C# app)
echo "🔨 Building medium level test runner..."
cd /workspace/medium && docker compose build testrunner &> /dev/null
echo "✓ Medium test runner built"

# Build hard level test runner
echo "🔨 Building hard level test runner..."
cd /workspace/hard && docker compose build test &> /dev/null
echo "✓ Hard test runner built"

# Make scripts executable
chmod +x /workspace/easy/evaluate.sh 2>/dev/null || true
chmod +x /workspace/hard/evaluate.sh 2>/dev/null || true
chmod +x /workspace/medium/Makefile 2>/dev/null || true

echo "✅ Environment setup complete!"
echo ""
echo "📊 Services running:"
echo "  - PostgreSQL: localhost:5432 (user: postgres, password: postgres, database: sqlpracticedb)"
echo "  - MongoDB: localhost:27017 (database: hardlevel)"
echo ""
echo "🎯 Ready to evaluate tasks!"
exit 0
