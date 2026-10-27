# run.ps1 - Safe Flutter run script for Windows
# Kills stale Java/Gradle processes and clears locked build dirs before running

Write-Host "Stopping any stale Java/Gradle processes..." -ForegroundColor Yellow
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Sleep -Seconds 2

Write-Host "Clearing build directory..." -ForegroundColor Yellow
Remove-Item -Recurse -Force ".\build" -ErrorAction SilentlyContinue

Write-Host "Starting flutter run..." -ForegroundColor Green
flutter run --android-skip-build-dependency-validation
