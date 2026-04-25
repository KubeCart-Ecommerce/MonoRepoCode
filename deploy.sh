#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "🚀 Starting Kubernetes deployment for KubeCart Microservices..."

echo "📦 1. Creating Namespace ('dev')..."
kubectl apply -f namespace.yaml

echo "💾 2. Creating NFS StorageClass..."
kubectl apply -f storage/

echo "🗄️  3. Deploying MongoDB StatefulSets (Database-per-service)..."
kubectl apply -f mongodb/

echo "⏳ Waiting for MongoDB PVCs to bind and StatefulSets to initialize..."
# Brief pause to let PVCs and Pods register before services try to connect
sleep 5

echo "⚙️  4. Deploying Node.js Microservices..."
kubectl apply -f services/

echo "🖥️  5. Deploying Frontend Application..."
kubectl apply -f frontend/

echo "🌐 6. Deploying Envoy API Gateway & HTTPRoutes..."
kubectl apply -f gateway/

echo "✅ Deployment manifests applied successfully!"
echo "➡️  Run 'kubectl get pods -n dev -w' to monitor the startup progress."
echo "➡️  Run 'kubectl get gateway -n dev' to get the LoadBalancer IP."
