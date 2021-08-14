﻿
function Get-RegInformation {
    <#
    Param(
     [parameter(Mandatory=$true)]
     [ValidateSet("x64", "x86")]
     [String[]]$Architecture
    )#>

    Try {
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
    Catch {

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
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
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

Export-ModuleMember -Function Get-ApplicationInfo