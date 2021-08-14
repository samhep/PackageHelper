
function Get-RegInformation {
    <#
    Param(
     [parameter(Mandatory=$true)]
     [ValidateSet("x64", "x86")]
     [String[]]$Architecture
    )#>

    Try {
          $regKeys = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
          Get-ChildItem $regKeys -rec -ea SilentlyContinue | ForEach-Object { 
              $CurrentKey = Get-ItemProperty -Path $_.PsPath
              if ($CurrentKey.DisplayName -ne $null) {
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

                  Return $appConfig
              }


          }   

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


    $regInformation = Get-RegInformation

    foreach($app in $regInformation) {
    
        if(Select-String -InputObject $app.DisplayName -Pattern $SearchTerm -SimpleMatch){
            
           
            $matchedappConfig = [PSCustomObject]@{
                  
                DisplayName = $app.DisplayName
                DisplayVersion = $app.DisplayVersion
                InstallLocation = $app.InstallLocation
                InstallSource = $app.InstallSource
                InstallDate = $app.InstallDate
                Publisher = $app.Publisher
                UninstallString = $app.UninstallString
                QuietUninstallString = $app.QuietUninstallString
                PSPath = $app.PSPath
                Error = $false
                ErrorMessage = $null

            }
            
                        
        }
    
    }


    Return $matchedappConfig
    
}


Export-ModuleMember -Function Get-ApplicationInfo