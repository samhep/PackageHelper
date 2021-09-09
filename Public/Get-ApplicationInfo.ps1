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

            $matchedAppConfig | Format-List

            $discoveredEXEs = Get-ChildItem -Path $matchedAppConfig.InstallLocation -Filter "*.exe" -Recurse

            $shortcuts = Get-ChildItem -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\" -Filter "*.lnk" -Recurse

            $sh = New-Object -ComObject WScript.Shell

            $targetList = @{}
            
            $shortcuts | ForEach-Object {

                $path = Convert-Path -Path $_.PSPath
                $target = $sh.CreateShortcut($path).TargetPath
                
                $targetList.Add($path, $target)

            }

            $discoveredEXEs  | ForEach-Object {
                $path = Convert-Path -Path $_.PSPath

                $targetList.GetEnumerator() | ForEach-Object {

                    if ($path -eq $_.Value) {

                        Write-Host "`nMatching exe and shortcut found:`n" -ForegroundColor Blue
                        Write-Host "Executable : $path" -ForegroundColor Green
                        Write-Host "Shortcut Target: $($_.Name)" -ForegroundColor Green
                    }

                }
            }

            Write-Host "`nExecutables found in Program Directory ($($matchedAppConfig.InstallLocation)):"

            $discoveredEXEs.VersionInfo | Format-Table -Property OriginalFilename, FileVersion
                        
        }
    
    }

}