Param(
  [parameter(mandatory=$true)][string]$Distro,
  [parameter(mandatory=$true)][string]$InstallLocation
)

$ErrorActionPreference = "Stop"

#$uri = "http://cdimage.ubuntu.com/ubuntu-base/releases/20.04.3/release/ubuntu-base-20.04.3-base-amd64.tar.gz"
$uri = "http://ftp.jaist.ac.jp/pub/Linux/ubuntu-cdimage/ubuntu-base/releases/20.04.3/release/ubuntu-base-20.04.3-base-amd64.tar.gz"
$sha256sum = "512F08F3583F79DC33FF24B1AB9324151110FF4E2D542114A206BEE75066BDD9"
$tarball = Join-Path $PSScriptRoot ([System.IO.Path]::GetFileName($uri))

If (![System.IO.File]::Exists($tarball)) {
  Invoke-WebRequest -Uri $uri -OutFile $tarball
}

$hash = (Get-FileHash $tarball -Algorithm SHA256).Hash
If ($hash -ne $sha256sum) {
  Write-Error "Checksum failed. Please delete $tarball manually."
}

wsl.exe --import $Distro $InstallLocation $tarball

$scriptsdir = Join-Path $PSScriptRoot "scripts"
Get-ChildItem $scriptsdir -Filter *.sh | Sort-Object -Property FullName | Foreach-Object {
  (Get-Content $_.FullName) -join "`n" | wsl.exe -d $Distro /bin/bash -l
}

wsl.exe -t $Distro

Remove-Item $tarball
#
