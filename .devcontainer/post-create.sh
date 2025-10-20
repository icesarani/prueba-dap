#!/bin/bash
set -e

echo "🚀 Setting up DAP-ORT evaluation environment..."

# Install required tools
echo "📦 Installing tools..."
sudo apt-get update -qq
sudo apt-get install -y make curl &> /dev/null
echo "✓ Tools installed"

# Wait for SQL Server to be healthy
echo "⏳ Waiting for SQL Server..."
for i in {1..60}; do
    if /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -Q "SELECT 1" -C &> /dev/null; then
        echo "✓ SQL Server is ready"
        break
    fi
    if [ $i -eq 60 ]; then
        echo "⚠ SQL Server did not start in time"
    fi
    sleep 2
done

# Initialize SQL Server database
echo "📊 Initializing SQL database..."
/opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "YourStrong@Passw0rd" -i /scripts/init-db.sql -C &> /dev/null || echo "⚠ Database might already be initialized"
echo "✓ SQL database ready"

# Wait for MongoDB to be healthy
echo "⏳ Waiting for MongoDB..."
for i in {1..30}; do
    if mongosh --eval "db.adminCommand('ping')" &> /dev/null; then
        echo "✓ MongoDB is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "⚠ MongoDB did not start in time"
    fi
    sleep 2
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
echo "  - SQL Server: localhost:1433 (user: sa, password: YourStrong@Passw0rd)"
echo "  - MongoDB: localhost:27017 (database: hardlevel)"
echo ""
echo "🎯 Ready to evaluate tasks!"
exit 0
