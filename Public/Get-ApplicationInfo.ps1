function Get-ApplicationInfo {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER SearchTerm
    Parameter description
    
    .EXAMPLE
    Get-ApplicationInfo -SearchTerm "Git"
    
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