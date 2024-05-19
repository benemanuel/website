$directoryPath = "C:\Users\avi\GitHub\website.benemanuel\_posts\blog\"
$compressedFilePath = "C:\Users\avi\GitHub\website.benemanuel\_posts\blog.7z"

# Compress the directory using 7z
& "C:\Program Files\7-Zip\7z.exe" a -t7z -mx9 "$compressedFilePath" "$directoryPath\*"


# Get all files in the directory
$files = Get-ChildItem -Path $directoryPath

foreach ($file in $files) {
    # Read the content of the file
    $content = Get-Content $file.FullName -Raw

    # Find the position of "original:" in the content
    $startIndex = $content.IndexOf("original:")

    # If "original:" is found, truncate the content from that point
    if ($startIndex -ne -1) {
        $content = $content.Substring(0, $startIndex)
        
        # Save the modified content back to the file
        Set-Content -Path $file.FullName -Value $content
    }
}
