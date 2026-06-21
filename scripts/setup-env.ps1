# scripts/setup-env.ps1
# Lance ce script au début de chaque session de travail : . .\scripts\setup-env.ps1

$paths = @(
    "C:\Users\msi\AppData\Local\Microsoft\WinGet\Packages\k3d.k3d_Microsoft.Winget.Source_8wekyb3d8bbwe",
    "C:\Users\msi\AppData\Local\Microsoft\WinGet\Packages\Helm.Helm_Microsoft.Winget.Source_8wekyb3d8bbwe\windows-amd64",
    "C:\Program Files (x86)\GnuWin32\bin"
)

foreach ($path in $paths) {
    if ($env:PATH -notlike "*$path*") {
        $env:PATH += ";$path"
        Write-Host "Ajouté au PATH : $path" -ForegroundColor Green
    }
}

Write-Host "`nEnvironnement prêt. Vérification :" -ForegroundColor Cyan
k3d version
helm version
make --version