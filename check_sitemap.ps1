# Define the sitemap URL and output file path
$sitemapUrl = "https://benemanuel.geulah.org.il/sitemap.xml"
$reportPath = "$HOME\Desktop\DeadLinksReport.csv"

Write-Host "Downloading sitemap from $sitemapUrl..." -ForegroundColor Cyan

try {
    # Download the XML content
    $response = Invoke-WebRequest -Uri $sitemapUrl -UseBasicParsing
    $xml = [xml]$response.Content

    # Define the XML namespace for sitemaps
    $ns = New-Object System.Xml.XmlNamespaceManager($xml.NameTable)
    $ns.AddNamespace("ns", "http://www.sitemaps.org/schemas/sitemap/0.9")

    # Extract all <loc> tags (URLs)
    $urls = $xml.SelectNodes("//ns:loc", $ns).'#text'
    Write-Host "Found $($urls.Count) links to check." -ForegroundColor Cyan

    $results = @()
    $count = 1

    foreach ($url in $urls) {
        Write-Host "[$count/$($urls.Count)] Checking: $url" -NoNewline
        
        try {
            # We use the HEAD method to check status without downloading the whole page
            $check = Invoke-WebRequest -Uri $url -Method Head -TimeoutSec 10 -ErrorAction Stop
            $status = $check.StatusCode
            Write-Host " [OK: $status]" -ForegroundColor Green
        }
        catch {
            # Catch 404, 500, or connection errors
            $status = $_.Exception.Response.StatusCode.value__
            if (!$status) { $status = "Connection Failed" }
            Write-Host " [DEAD: $status]" -ForegroundColor Red
            
            # Add to the results list
            $results += [PSCustomObject]@{
                URL        = $url
                Status     = $status
                CheckDate  = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            }
        }
        $count++
    }

    # Export dead links to CSV
    if ($results.Count -gt 0) {
        $results | Export-Csv -Path $reportPath -NoTypeInformation
        Write-Host "`nAnalysis complete. Found $($results.Count) dead links." -ForegroundColor Yellow
        Write-Host "Report saved to: $reportPath" -ForegroundColor White
    }
    else {
        Write-Host "`nSuccess! All links in the sitemap returned a valid status." -ForegroundColor Green
    }

}
catch {
    Write-Error "Failed to process sitemap: $($_.Exception.Message)"
}