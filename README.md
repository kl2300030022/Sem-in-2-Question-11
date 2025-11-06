# Event Management - Cloud Native Modernization

This repository contains the Event Management fullstack application (frontend + backend + MySQL) and a Helm chart to deploy it to Kubernetes with Ingress and HPA support.

What's included
- 11-Backend/ (Java backend source)
- 11-frontend/ (React frontend source)
- Helm-Chart-Template-master/Helm-Chart-Template-master (Helm chart with templates for MySQL, backend, frontend, services, ingress, HPA)
- Dockerfiles for backend and frontend (in the Helm chart folder)
- CI workflow to build & push Docker images and run Helm lint (GitHub Actions)
- Helper PowerShell scripts to build/push images and deploy the Helm chart locally

Prerequisites
- Docker (desktop)
- kubectl
- Helm 3
- A Kubernetes cluster (Docker Desktop Kubernetes, minikube, kind, or cloud cluster)
- (Optional) A Docker Hub account to push images

Quick local deploy (PowerShell)
1. Build and push images (replace `<your-docker-username>`):

```powershell
# Build
.\scripts\build_and_push.ps1 -DockerUser <your-docker-username> -Tag latest
```

2. (Optional) Create Kubernetes namespace and image pull secret if images are private:

```powershell
kubectl create namespace ecommerce
kubectl create secret docker-registry regcred --docker-server=https://index.docker.io/v1/ --docker-username=<your-user> --docker-password=<your-pass> --docker-email=<email> -n ecommerce
# Then set imagePullSecrets in Helm values.yaml
```

3. Install ingress and metrics-server (if not already):

```powershell
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx; helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

4. Deploy Helm chart:

```powershell
helm upgrade --install ecommerce .\Helm-Chart-Template-master\Helm-Chart-Template-master -n ecommerce --create-namespace -f .\Helm-Chart-Template-master\Helm-Chart-Template-master\values.yaml
```

5. Verify:

```powershell
kubectl get all -n ecommerce
kubectl get hpa -n ecommerce
kubectl get ingress -n ecommerce
```

CI (GitHub Actions)
- The included workflow `.github/workflows/ci.yml` can build and push Docker images and run `helm lint`. It expects secrets:
  - `DOCKERHUB_USERNAME`
  - `DOCKERHUB_TOKEN` (or `DOCKERHUB_PASSWORD`)

How to publish this repo to GitHub
1. Create a new repository on GitHub (name it e.g. `event-management-k8s`).
2. Run the following locally (replace `<git-remote-url>`):

```powershell
git remote add origin <git-remote-url>
git branch -M main
git push -u origin main
```

If you'd like, I can push this repo for you if you provide a repository URL and a token with repo permissions (or add me as a collaborator) — otherwise follow the steps above.

Support
- If you want TLS automation, I can add `cert-manager` manifests and a ClusterIssuer for Let's Encrypt.
- If you want CI to also deploy to a cluster, we can wire KUBECONFIG as a secret in GitHub Actions.

---

Ready to help push this to GitHub or wire CI — tell me if you want me to push (provide remote URL/token) or I should just give the final push commands.