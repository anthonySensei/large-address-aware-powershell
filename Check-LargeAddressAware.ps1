param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

function Check-LargeAddressAware {
    param([string]$FilePath)
    
    if (!(Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        exit 1
    }

    try {
        $bytes = [System.IO.File]::ReadAllBytes($FilePath)
        
        # Check if it's a valid PE file
        if ($bytes[0] -ne 0x4D -or $bytes[1] -ne 0x5A) {
            Write-Error "Not a valid PE file"
            exit 1
        }
        
        # Get PE header offset
        $peOffset = [BitConverter]::ToUInt32($bytes, 0x3C)
        
        # Check PE signature
        if ([BitConverter]::ToUInt32($bytes, $peOffset) -ne 0x00004550) {
            Write-Error "Invalid PE signature"
            exit 1
        }
        
        # Get characteristics and check the flag
        $characteristicsOffset = $peOffset + 22
        $characteristics = [BitConverter]::ToUInt16($bytes, $characteristicsOffset)
        
        $isLargeAddressAware = ($characteristics -band 0x20) -ne 0
        
        Write-Host "File: $FilePath"
        Write-Host "Large Address Aware: " -NoNewline
        
        if ($isLargeAddressAware) {
            Write-Host "ENABLED" -ForegroundColor Green
        } else {
            Write-Host "DISABLED" -ForegroundColor Red
        }
        
    } catch {
        Write-Error "Error reading file: $($_.Exception.Message)"
        exit 1
    }
}

# Call the function with the provided file path
Check-LargeAddressAware $FilePath