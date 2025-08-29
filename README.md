# Large Address Aware PowerShell Tools

Enable 4GB RAM usage for 32-bit Windows applications using pure PowerShell scripts - no external tools or Visual Studio required.

## What This Does

Modifies the PE header of 32-bit executables to set the `LARGE_ADDRESS_AWARE` flag, allowing them to use up to 4GB of RAM on 64-bit Windows systems (instead of the default 2GB limit).

## Why Use This?

- **No external downloads** - Uses built-in Windows PowerShell
- **No Visual Studio required** - Alternative to `editbin.exe`
- **Safe** - Creates automatic backups before modification
- **Open source** - See exactly what it does to your files
- **Lightweight** - Just a few KB of PowerShell code

## Perfect For

- 32-bit games that run out of memory (Mafia II, older titles)
- Legacy business applications
- Development tools with memory constraints
- Anyone who needs PE header modification without installing Visual Studio

## Quick Start

```powershell
# Check if already enabled
.\Check-LargeAddressAware.ps1 "path\to\your\app.exe"

# Enable 4GB support
.\Enable-LargeAddressAware.ps1 "path\to\your\app.exe"
```
## GitHub Topics/Tags
powershell, windows, pe-header, memory-management, 32bit, gaming, executable-modification, 4gb-patch, large-address-aware