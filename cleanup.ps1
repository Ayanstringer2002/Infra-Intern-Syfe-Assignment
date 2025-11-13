#!/bin/bash

Write-Host "Cleaning up deployment..." -ForegroundColor Cyan

try {
    helm uninstall wordpress
    Write-Host "✓ WordPress deployment removed" -ForegroundColor Green
}
catch {
    Write-Host "! WordPress deployment not found or already removed" -ForegroundColor Yellow
}

try {
    helm uninstall monitoring
    Write-Host "✓ Monitoring deployment removed" -ForegroundColor Green
}
catch {
    Write-Host "! Monitoring deployment not found or already removed" -ForegroundColor Yellow
}

Write-Host "Stopping Minikube..." -ForegroundColor Cyan
minikube stop

Write-Host "Cleanup completed!" -ForegroundColor Green
Write-Host "`nTo start fresh, run: .\deploy.ps1" -ForegroundColor Gray