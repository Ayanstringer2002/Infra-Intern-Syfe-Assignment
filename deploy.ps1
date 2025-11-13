#!/bin/bash

try {
    Write-Host "Starting Minikube..." -ForegroundColor Cyan
    minikube start --cpus=4 --memory=8192 --disk-size=20g

    Write-Host "Enabling ingress and metrics-server..." -ForegroundColor Cyan
    minikube addons enable ingress
    minikube addons enable metrics-server

    Write-Host "Setting up Docker environment for Minikube..." -ForegroundColor Cyan
    # For PowerShell, use this instead of eval $(minikube docker-env)
    minikube docker-env | Invoke-Expression

    Write-Host "Building Docker images..." -ForegroundColor Green
    
    Write-Host "Building WordPress image..." -ForegroundColor Yellow
    docker build -t wordpress-custom:latest -f docker/wordpress/Dockerfile .
    
    Write-Host "Building MySQL image..." -ForegroundColor Yellow
    docker build -t mysql-custom:latest -f docker/mysql/Dockerfile .
    
    Write-Host "Building Nginx image..." -ForegroundColor Yellow
    docker build -t nginx-openresty:latest -f docker/nginx/Dockerfile .

    Write-Host "Deploying WordPress..." -ForegroundColor Cyan
    helm dependency update charts/wordpress
    helm install wordpress charts/wordpress/ -f charts/wordpress/values.yaml

    Write-Host "Deploying Monitoring..." -ForegroundColor Cyan
    helm dependency update charts/monitoring
    helm install monitoring charts/monitoring/ -f charts/monitoring/values.yaml

    Write-Host "Waiting for pods to be ready..." -ForegroundColor Yellow
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=wordpress --timeout=300s

    Write-Host "Deployment completed!" -ForegroundColor Green
    
    Write-Host "`nAccess URLs:" -ForegroundColor Cyan
    $wordpressUrl = minikube service wordpress-nginx --url
    $grafanaUrl = minikube service monitoring-grafana --url
    
    Write-Host "WordPress URL: $wordpressUrl" -ForegroundColor White
    Write-Host "Grafana URL: $grafanaUrl" -ForegroundColor White
    Write-Host "`nGrafana credentials: admin / admin123" -ForegroundColor Yellow
    
    Write-Host "`nTo check status, run: kubectl get pods" -ForegroundColor Gray
}
catch {
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}