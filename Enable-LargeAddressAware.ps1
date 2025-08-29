param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

function Enable-LargeAddressAware {
    param([string]$FilePath)
    
    if (!(Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }
    
    # Backup original file
    Copy-Item $FilePath "$FilePath.backup"
    
    try {
        $bytes = [System.IO.File]::ReadAllBytes($FilePath)
        
        # Check if it's a valid PE file
        if ($bytes[0] -ne 0x4D -or $bytes[1] -ne 0x5A) {
            Write-Error "Not a valid PE file"
            return
        }
        
        # Get PE header offset
        $peOffset = [BitConverter]::ToUInt32($bytes, 0x3C)
        
        # Check PE signature
        if ([BitConverter]::ToUInt32($bytes, $peOffset) -ne 0x00004550) {
            Write-Error "Invalid PE signature"
            return
        }
        
        # Get characteristics offset and current value
        $characteristicsOffset = $peOffset + 22
        $characteristics = [BitConverter]::ToUInt16($bytes, $characteristicsOffset)
        
        # Check if already set
        if ($characteristics -band 0x20) {
            Write-Host "Large Address Aware flag is already set"
            return
        }
        
        # Set the LARGE_ADDRESS_AWARE flag (0x20)
        $newCharacteristics = $characteristics -bor 0x20
        [BitConverter]::GetBytes([uint16]$newCharacteristics).CopyTo($bytes, $characteristicsOffset)
        
        # Write back to file
        [System.IO.File]::WriteAllBytes($FilePath, $bytes)
        Write-Host "Successfully enabled Large Address Aware for: $FilePath"
        
    } catch {
        Write-Error "Error modifying file: $($_.Exception.Message)"
        # Restore backup on error
        if (Test-Path "$FilePath.backup") {
            Copy-Item "$FilePath.backup" $FilePath -Force
        }
    }
}

# Call the function with the provided file path
Enable-LargeAddressAware $FilePath