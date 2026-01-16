[CmdletBinding()]
param (
    [Parameter(HelpMessage = "http/https proxy")]
    [string]
    $proxy
)
If ($proxy.Length -ne 0) {
    python -m pip --proxy $proxy install --upgrade pip
    pip list --proxy $proxy --outdated --format json > pip_outdated_packages.json
    $outdated_packages = Get-Content .\pip_outdated_packages.json -Raw | ConvertFrom-Json
    ForEach ($package in $outdated_packages) {
        python -m pip --proxy $proxy install --upgrade $package.name
    }
    Remove-Item pip_outdated_packages.json
} Else {
    python -m pip install --upgrade pip
    pip list --outdated --format json > pip_outdated_packages.json
    $outdated_packages = Get-Content .\pip_outdated_packages.json -Raw | ConvertFrom-Json
    ForEach ($package in $outdated_packages) {
        python -m pip install --upgrade $package.name
    }
    Remove-Item pip_outdated_packages.json
}
