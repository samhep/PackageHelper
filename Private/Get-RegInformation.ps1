function Get-RegInformation {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .EXAMPLE
    Get-RegInformation
    
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