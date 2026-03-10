# Bootstrap script for E2EE Chat App

Write-Host "Iniciando bootstrap del proyecto E2EE Chat App..." -ForegroundColor Cyan

# 1. Check dependencies
$commands = @("docker", "npm", "flutter")
foreach ($cmd in $commands) {
    if (!(Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Host "ADVERTENCIA: $cmd no está instalado o no está en el PATH." -ForegroundColor Yellow
    }
}

# 2. Setup Backend
Write-Host "Configurando Backend..." -ForegroundColor Green
cd apps/backend
npm install
cd ../..

# 3. Setup Mobile
Write-Host "Configurando Mobile..." -ForegroundColor Green
cd apps/mobile
# flutter pub get # (Descomentar si tienes flutter instalado)
cd ../..

Write-Host "Estructura creada con éxito." -ForegroundColor Cyan
Write-Host "Para iniciar la infraestructura: cd infra; docker-compose up -d" -ForegroundColor Green
