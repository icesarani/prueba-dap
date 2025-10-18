#!/bin/bash
# Don't exit on error - we want to continue even if some steps fail
set +e

echo "Setting up DAP-ORT evaluation environment..."

# Create docker-compose wrapper if it doesn't exist
if ! command -v docker-compose &> /dev/null; then
    echo "Creating docker-compose compatibility wrapper..."

    # Try with sudo first
    if command -v sudo &> /dev/null; then
        cat > /tmp/docker-compose << 'EOF'
#!/bin/bash
docker compose "$@"
EOF
        sudo chmod +x /tmp/docker-compose 2>/dev/null || chmod +x /tmp/docker-compose
        sudo mv /tmp/docker-compose /usr/local/bin/docker-compose 2>/dev/null || {
            # If sudo fails, try without sudo
            mv /tmp/docker-compose ~/docker-compose 2>/dev/null
            echo 'export PATH="$HOME:$PATH"' >> ~/.bashrc
        }
    else
        # No sudo, create in home directory
        cat > ~/docker-compose << 'EOF'
#!/bin/bash
docker compose "$@"
EOF
        chmod +x ~/docker-compose
        echo 'export PATH="$HOME:$PATH"' >> ~/.bashrc
    fi
    echo "✓ docker-compose wrapper created"
fi

# Install make if not available (non-blocking)
if ! command -v make &> /dev/null; then
    echo "Installing make..."
    if command -v sudo &> /dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y make &> /dev/null && echo "✓ make installed" || echo "⚠ Could not install make"
    else
        apt-get update -qq && apt-get install -y make &> /dev/null && echo "✓ make installed" || echo "⚠ Could not install make"
    fi
fi

# Wait for Docker to be ready (non-blocking)
echo "Waiting for Docker daemon..."
for i in {1..30}; do
    if docker ps &> /dev/null; then
        echo "✓ Docker is running"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "⚠ Docker is not ready yet, but continuing..."
    fi
    sleep 1
done

echo "✓ Environment setup complete!"
exit 0
