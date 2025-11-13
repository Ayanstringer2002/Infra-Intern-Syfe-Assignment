#!/bin/bash

# Set your Docker Hub username
$DOCKER_USERNAME = "marcusayan"

Write-Host "Starting Docker image builds..." -ForegroundColor Yellow

# Build WordPress image
Write-Host "Building WordPress image..." -ForegroundColor Green
docker build -t $DOCKER_USERNAME/wordpress-custom:latest -f docker/wordpress/Dockerfile .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ WordPress image built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ WordPress image build failed" -ForegroundColor Red
    exit 1
}

# Build MySQL image
Write-Host "Building MySQL image..." -ForegroundColor Green
docker build -t $DOCKER_USERNAME/mysql-custom:latest -f docker/mysql/Dockerfile .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ MySQL image built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ MySQL image build failed" -ForegroundColor Red
    exit 1
}

# Build Nginx image
Write-Host "Building Nginx with OpenResty image..." -ForegroundColor Green
docker build -t $DOCKER_USERNAME/nginx-openresty:latest -f docker/nginx/Dockerfile .
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Nginx image built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Nginx image build failed" -ForegroundColor Red
    exit 1
}

# List all built images
Write-Host "Built images:" -ForegroundColor Yellow
docker images | Select-String $DOCKER_USERNAME

Write-Host "All images built successfully!" -ForegroundColor Green

# Optional: Push to Docker Hub
$response = Read-Host "Would you like to push images to Docker Hub? (y/n)"
if ($response -eq 'y' -or $response -eq 'Y') {
    Write-Host "Pushing images to Docker Hub..." -ForegroundColor Green
    
    # Login to Docker Hub first (uncomment if needed)
    # docker login
    
    docker push $DOCKER_USERNAME/wordpress-custom:latest
    docker push $DOCKER_USERNAME/mysql-custom:latest
    docker push $DOCKER_USERNAME/nginx-openresty:latest
    
    Write-Host "✓ All images pushed to Docker Hub" -ForegroundColor Green
} else {
    Write-Host "Images not pushed to Docker Hub" -ForegroundColor Yellow
}