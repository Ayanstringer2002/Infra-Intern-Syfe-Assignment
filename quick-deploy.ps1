#!/bin/bash

# Quick deployment script for testing

Write-Host "🚀 Quick WordPress Kubernetes Deployment" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta

# Check if Minikube is running
$minikubeStatus = minikube status --format "{{.Host}}"
if ($minikubeStatus -ne "Running") {
    Write-Host "Starting Minikube..." -ForegroundColor Yellow
    minikube start --cpus=2 --memory=4096
    minikube addons enable ingress
    minikube addons enable metrics-server
}

# Build images
Write-Host "Building Docker images..." -ForegroundColor Yellow
minikube docker-env | Invoke-Expression

docker build -t wordpress-custom:latest -f docker/wordpress/Dockerfile .
docker build -t mysql-custom:latest -f docker/mysql/Dockerfile . 
docker build -t nginx-openresty:latest -f docker/nginx/Dockerfile .

# Deploy
Write-Host "Deploying applications..." -ForegroundColor Yellow
helm install wordpress charts/wordpress/ -f charts/wordpress/values.yaml

Write-Host "✅ Deployment completed!" -ForegroundColor Green
Write-Host "`nAccess your application:" -ForegroundColor Cyan
Write-Host "WordPress: $(minikube service wordpress-nginx --url)" -ForegroundColor White
Write-Host "`nCheck status: kubectl get pods" -ForegroundColor Gray