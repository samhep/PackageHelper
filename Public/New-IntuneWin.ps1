function New-IntuneWin {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    New-IntuneWin -SourceFolder C:\Users\exampleuser\Downloads\nuget -InstallFile nuget.exe
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $SourceFolder,
        [Parameter(Mandatory)]
        [string] $InstallFile,
        [Parameter()]
        [string] $Output = "C:\PackageHelper\Export\IntuneWin"
    )

    try {

        $IntuneWinAppUtil = "C:\PackageHelper\Tools\IntuneWinAppUtil\IntuneWinAppUtil.exe"

        if (!(Test-Path $IntuneWinAppUtil)) {
            Get-IntuneWin32Tool
        }
       

        if (Test-Path -Path "$SourceFolder\$InstallFile") {
            Start-Process -FilePath $IntuneWinAppUtil -ArgumentList "-c $SourceFolder -s $InstallFile -o $Output -q" -WindowStyle Hidden -Wait
        }

    }
    catch {
        
    }
    
}