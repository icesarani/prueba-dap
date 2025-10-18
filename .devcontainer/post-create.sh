#!/bin/bash
set -e

echo "Setting up DAP-ORT evaluation environment..."

# Create symlink for docker-compose (v1 command) to docker compose (v2)
# This ensures compatibility with Makefiles that use docker-compose
if ! command -v docker-compose &> /dev/null; then
    echo "Creating docker-compose compatibility wrapper..."
    cat > /tmp/docker-compose << 'EOF'
#!/bin/bash
docker compose "$@"
EOF
    sudo chmod +x /tmp/docker-compose
    sudo mv /tmp/docker-compose /usr/local/bin/docker-compose
    echo "✓ docker-compose wrapper created"
fi

# Verify Docker is available
if docker ps &> /dev/null; then
    echo "✓ Docker is running"
else
    echo "⚠ Docker is not running yet, it will be available shortly"
fi

# Install make if not available
if ! command -v make &> /dev/null; then
    echo "Installing make..."
    sudo apt-get update && sudo apt-get install -y make
    echo "✓ make installed"
fi

echo "✓ Environment setup complete!"
