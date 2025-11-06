param(
  [string]$ValuesFile = "Helm-Chart-Template-master\Helm-Chart-Template-master\values.yaml",
  [string]$ChartPath = "Helm-Chart-Template-master\Helm-Chart-Template-master",
  [string]$Release = "ecommerce",
  [string]$Namespace = "ecommerce"
)

Write-Host "Linting chart..."
helm lint $ChartPath -f $ValuesFile

Write-Host "Installing ingress-nginx (if missing)..."
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx | Out-Null
helm repo update | Out-Null
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

Write-Host "Applying metrics-server..."
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

Write-Host "Deploying Helm chart..."
helm upgrade --install $Release $ChartPath -n $Namespace --create-namespace -f $ValuesFile

Write-Host "Done. Verify with: kubectl get all -n $Namespace"}