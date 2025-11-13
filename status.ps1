#!/bin/bash

Write-Host "📊 Kubernetes Deployment Status" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

Write-Host "`nHelm Releases:" -ForegroundColor Yellow
helm list

Write-Host "`nPods:" -ForegroundColor Yellow
kubectl get pods

Write-Host "`nServices:" -ForegroundColor Yellow
kubectl get services

Write-Host "`nPersistent Volumes:" -ForegroundColor Yellow
kubectl get pvc

Write-Host "`nAccess URLs:" -ForegroundColor Green
try {
    $wpUrl = minikube service wordpress-nginx --url
    Write-Host "WordPress: $wpUrl" -ForegroundColor White
} catch {
    Write-Host "WordPress service not ready yet" -ForegroundColor Red
}

try {
    $grafanaUrl = minikube service monitoring-grafana --url
    Write-Host "Grafana: $grafanaUrl" -ForegroundColor White
} catch {
    Write-Host "Grafana service not found" -ForegroundColor Yellow
}