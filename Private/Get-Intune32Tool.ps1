function Get-IntuneWin32Tool {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    Get-IntuneWin32Tool
    
    .NOTES
    General notes
    #>

    try {

        # See if tool is already available

        if (Test-Path -Path "C:\PackageHelper\Tools\IntuneWinAppUtil\IntuneWinAppUtil.exe") {
            Write-Host "Intune Win32 Util is already available."
        } else {
            # Check for paths

            if (!(Test-Path -Path "C:\PackageHelper\Tools")) {
                New-Item -Path "C:\PackageHelper\" -ItemType Directory -Name "Tools"
            }
            if (!(Test-Path -Path "C:\PackageHelper\Temp")) {
                New-Item -Path "C:\PackageHelper\" -ItemType Directory -Name "Temp"
            }
            if (!(Test-Path -Path "C:\PackageHelper\Temp\IntuneWinAppUtil")) {
                New-Item -Path "C:\PackageHelper\Temp" -ItemType Directory -Name "IntuneWinAppUtil"
            }

            Invoke-WebRequest -Uri "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/archive/refs/tags/1.8.3.zip" -OutFile "C:\PackageHelper\Temp\IntuneWinAppUtil\IntuneWin32Tool.zip" 

            Expand-Archive -Path "C:\PackageHelper\Temp\IntuneWinAppUtil\IntuneWin32Tool.zip" -DestinationPath "C:\PackageHelper\Temp\IntuneWinAppUtil\IntuneWin32Tool"

            if (!(Test-Path -Path "C:\PackageHelper\Tools\IntuneWinAppUtil")) {
                New-Item -Path "C:\PackageHelper\Tools\" -ItemType Directory -Name "IntuneWinAppUtil"
            }

            Copy-Item -Path "C:\PackageHelper\Temp\IntuneWinAppUtil\IntuneWin32Tool\Microsoft-Win32-Content-Prep-Tool-1.8.3\IntuneWinAppUtil.exe" -Destination "C:\PackageHelper\Tools\IntuneWinAppUtil\IntuneWinAppUtil.exe"

            Remove-Item -Path "C:\PackageHelper\Temp\IntuneWinAppUtil" -Recurse
        }
     

    }
    catch {
        
    }
}