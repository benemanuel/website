$ErrorActionPreference = "Stop"
$hasError = $false

# 1. Every file in _posts/** must have a Jekyll-recognized extension (md/markdown/html)
$validExt = @(".md", ".markdown", ".html", ".htm")
Get-ChildItem -Path (Join-Path $PSScriptRoot "_posts") -Recurse -File | ForEach-Object {
    if ($validExt -notcontains $_.Extension.ToLower()) {
        Write-Host "ERROR: Post is missing a recognized extension and Jekyll will ignore it: $($_.FullName)" -ForegroundColor Red
        Write-Host "       Expected pattern: YYYY-MM-DD-title.md" -ForegroundColor Red
        $script:hasError = $true
    }
    if ($_.Name -notmatch '^\d{4}-\d{2}-\d{2}-.+\.(md|markdown|html|htm)$') {
        Write-Host "ERROR: Post filename does not match YYYY-MM-DD-title.ext: $($_.FullName)" -ForegroundColor Red
        $script:hasError = $true
    }
}

# 2. Every post must have valid frontmatter (opening and closing ---)
Get-ChildItem -Path (Join-Path $PSScriptRoot "_posts") -Recurse -File | Where-Object { $validExt -contains $_.Extension.ToLower() } | ForEach-Object {
    $lines = Get-Content $_.FullName -TotalCount 50
    if ($lines.Count -lt 2 -or $lines[0].Trim() -ne "---") {
        Write-Host "ERROR: Post is missing opening frontmatter '---': $($_.FullName)" -ForegroundColor Red
        $script:hasError = $true
    } else {
        $closing = $false
        for ($i = 1; $i -lt $lines.Count; $i++) {
            if ($lines[$i].Trim() -eq "---") { $closing = $true; break }
        }
        if (-not $closing) {
            Write-Host "ERROR: Post is missing closing frontmatter '---': $($_.FullName)" -ForegroundColor Red
            $script:hasError = $true
        }
    }
}

# 3. Stray root index.html would override Jekyll's generated homepage
$rootIndex = Join-Path $PSScriptRoot "index.html"
if (Test-Path $rootIndex) {
    Write-Host "ERROR: A static index.html exists in the repo root and will override the generated homepage: $rootIndex" -ForegroundColor Red
    $script:hasError = $true
}

# 4. Warn (non-fatal) about uncommitted or unpushed changes
Push-Location $PSScriptRoot
$status = git status --porcelain
if ($status) {
    Write-Host "WARNING: You have uncommitted changes - they will not be deployed:" -ForegroundColor Yellow
    Write-Host $status
}
$unpushed = git log '@{u}..HEAD' --oneline 2>$null
if ($unpushed) {
    Write-Host "WARNING: You have local commits not yet pushed to the remote:" -ForegroundColor Yellow
    Write-Host $unpushed
}
Pop-Location

if ($script:hasError) {
    exit 1
} else {
    Write-Host "Pre-deploy checks passed." -ForegroundColor Green
    exit 0
}
