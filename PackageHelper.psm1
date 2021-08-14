
function Get-RegInformation {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    try {
            $regApps = New-Object System.Collections.ArrayList
            $regKeys = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
            Get-ChildItem $regKeys -rec -ea SilentlyContinue | ForEach-Object { 
                $CurrentKey = Get-ItemProperty -Path $_.PsPath
                if ($null -ne $CurrentKey.DisplayName) {
                    $appConfig = [PSCustomObject]@{
            
                        DisplayName = $CurrentKey.DisplayName
                        DisplayVersion = $CurrentKey.DisplayVersion
                        InstallLocation = $CurrentKey.InstallLocation
                        InstallSource = $CurrentKey.InstallSource
                        InstallDate = $CurrentKey.InstallDate
                        Publisher = $CurrentKey.Publisher
                        UninstallString = $CurrentKey.UninstallString
                        QuietUninstallString = $CurrentKey.QuietUninstallString
                        PSPath = $CurrentKey.PSPath
                        Error = $false
                        ErrorMessage = $null

                    }

                    $regApps.Add($appConfig) | Out-Null 
                }


            }   

            Return $regApps

    }
    catch {

            $errorMessage = $_.Exception.Message  
            $errorValue = "Error"

            $appConfig = [PSCustomObject]@{
                  
                DisplayName = $errorValue
                DisplayVersion = $errorValue
                InstallLocation = $errorValue
                InstallSource = $errorValue
                InstallDate = $errorValue
                Publisher = $errorValue
                UninstallString = $errorValue
                QuietUninstallString = $errorValue
                PSPath = $CurrentKey.PSPath
                Error = $true
                ErrorMessage = $errorMessage

            }

            Return $appConfig

            Break
    
    
    }

}

Function Get-ApplicationInfo {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER SearchTerm
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $SearchTerm
    )

    $matchedApps = New-Object System.Collections.ArrayList

    Get-RegInformation | ForEach-Object {
    
        if(Select-String -InputObject $_.DisplayName -Pattern $SearchTerm){
            

            $matchedAppConfig = [PSCustomObject]@{
                  
                DisplayName = $_.DisplayName
                DisplayVersion = $_.DisplayVersion
                InstallLocation = $_.InstallLocation
                InstallSource = $_.InstallSource
                InstallDate = $_.InstallDate
                Publisher = $_.Publisher
                UninstallString = $_.UninstallString
                QuietUninstallString = $_.QuietUninstallString
                PSPath = $_.PSPath
                Error = $false
                ErrorMessage = $null

            }

            $matchedApps.Add($matchedAppConfig) | Out-Null 
            
        }
    
    }

    Return $matchedApps

}

function Export-ApplicationConfig {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER obj
    Parameter description
    
    .PARAMETER FileType
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>

    [CmdletBinding()] 
    Param(
        [Parameter(ValueFromPipeline, Mandatory)][object] $obj, 
        [Parameter(Mandatory)][ValidateSet("json")][String[]] $FileType
    )
    Process{
        $obj | ForEach-Object {
            try {       

                switch ($FileType) {
                    json { 
                        $obj | ConvertTo-Json | Out-File -FilePath "C:\PackageHelper\Export\Configurations\$($obj.DisplayName).json" -Verbose
                    }
                    Default { $obj | ConvertTo-Json | Out-File -FilePath "C:\PackageHelper\Export\Configurations\$($obj.DisplayName).json" -Verbose }
                }
            }
            catch{}
        }
    }
 
}

function Get-IntuneWin32Tool {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
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

function New-IntuneWin {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    An example
    
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

Export-ModuleMember -Function Get-ApplicationInfo, Export-ApplicationConfig