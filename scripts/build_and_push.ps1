param(
  [Parameter(Mandatory=$true)]
  [string]$DockerUser,
  [string]$Tag = "latest"
)

Write-Host "Building backend..."
docker build -t $DockerUser/ecommerce-backend:$Tag -f "Helm-Chart-Template-master\Helm-Chart-Template-master\Dockerfile.backend" "Event-Management-main\11-Backend"

Write-Host "Pushing backend..."
docker push $DockerUser/ecommerce-backend:$Tag

Write-Host "Building frontend..."
docker build -t $DockerUser/ecommerce-frontend:$Tag -f "Helm-Chart-Template-master\Helm-Chart-Template-master\Dockerfile.frontend" "Event-Management-main\11-frontend"

Write-Host "Pushing frontend..."
docker push $DockerUser/ecommerce-frontend:$Tag

Write-Host "Done. Update Helm values.yaml if needed and run deploy script or helm upgrade --install."