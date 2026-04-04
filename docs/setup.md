# Setup Guide: Private Ethereum Node

## Prerequisites
- Docker & Docker Compose installed
- Geth (Go Ethereum) installed locally
- Node.js + npm (for client scripts)
- Optional: kubectl & Terraform for Kubernetes/IaC

---

## Step 1: Clone the Repo
```bash
git clone https://github.com/<your-username>/ethereum-private-node-iac.git
cd ethereum-private-node-iac

## Step 2 initialize accounts
geth account new --datadir docker/validator1
geth account new --datadir docker/validator2

## Step 3:Initialize nodes
geth init docker/genesis.json --datadir docker/validator1
geth init docker/genesis.json --datadir docker/validator2
geth init docker/genesis.json --datadir docker/rpcnode

## Step 4: Run with Docker Compose
cd docker
docker-compose up -d
##check logs
docker logs -f validator1
docker logs -f validator2
docker logs -f rpcnode

##Step 5: Connect via RPC
node client/web3-test.js

# Kubernetes Deployment Guide

## Prerequisites
- Kubernetes cluster (local with Minikube/kind or cloud)
- kubectl installed and configured
- Optional: Terraform for IaC automation

---

## Step 1: Apply Deployment
```bash
kubectl apply -f k8s/deployment.yaml

## Step 2: Apply the service
kubectl apply -f k8s/service.yaml

##Step 3: Verify the deployment
kubectl get pods
##Check service
kubectl get svc ethereum-service

## Step 4: connect via RPC
const Web3 = require("web3");
const web3 = new Web3("http://<node-ip>:<nodeport>");
(async () => {
  console.log(await web3.eth.getBlockNumber());
})();

## Step 5: Scaling
Duplicate the deployment with different names (validator1, validator2).
Update genesis.json with their addresses.
Apply again with kubectl.

