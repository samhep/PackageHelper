function Initialize-PackageHelper {
    <#
    .SYNOPSIS
    Short description
    
    .DESCRIPTION
    Long description
    
    .PARAMETER ModulePath
    Parameter description
    
    .EXAMPLE
    An example
    
    .NOTES
    General notes
    #>
    [CmdletBinding()]
    param (
        [string]$ModulePath,
        [switch]$CreatePaths
    )

    if (! (Test-Path HKCU:\Software\PackageHelper)) {
        Try {New-Item HKCU:\Software -Name PackageHelper -Force | Out-Null}
        Catch {Write-Warning 'Failed writing to HKCU'; Break}
    }

    if (! (Get-ItemProperty -Path HKCU:\Software\PackageHelper -Name ModulePath -ErrorAction SilentlyContinue)) {
        Try {
            New-ItemProperty -Path HKCU:\Software\PackageHelper -Name ModulePath -Force | Out-Null
            Set-ItemProperty -Path HKCU:\Software\PackageHelper -Name ModulePath -Value "C:\PackageHelper" -Force
        }
        Catch {Write-Warning 'Failed writing to HKCU'; Break}
    }



    if ($ModulePath) {
        Try {
            
            $pathLeaf = $ModulePath | Split-Path -Leaf

            if($pathLeaf -eq "PackageHelper"){
                Write-Verbose "Path already has PackageHelper"
                Set-ItemProperty -Path HKCU:\Software\PackageHelper -Name ModulePath -Value $ModulePath -Force
            } else {
                Write-Verbose "Path needs PackageHelper"
                Set-ItemProperty -Path HKCU:\Software\PackageHelper -Name ModulePath -Value (Join-Path $ModulePath 'PackageHelper') -Force
            }

            $global:PackageHelperModulePath = $(Get-ItemProperty "HKCU:\Software\PackageHelper").ModulePath

        }
        Catch {Write-Warning "Failed writing to HKCU | Path: $ModulePath"; Break}
    }

    if ($CreatePaths) {
        Try {
            
            if (! (Test-Path $global:PackageHelperModulePath) ){
                Try {New-Item ($global:PackageHelperModulePath | Split-Path) -Name PackageHelper -ItemType Directory -Force | Out-Null}
                Catch {Write-Warning 'Failed to create "$global:PackageHelperModulePath"'; Break}
            }
           
            $folders = "Export"
            
            $folders | ForEach-Object {

                if (! (Test-Path (Join-Path $global:PackageHelperModulePath $_)) ){
                    Try {New-Item -Path $global:PackageHelperModulePath -ItemType Directory -Name $_ -Force | Out-Null}
                    Catch {Write-Warning 'Failed to create "$global:PackageHelperModulePath"'; Break}
                }
               
            }

        }
        Catch {Write-Warning "Unable to make paths"; Break}
    }


    

    ## Setting up variables for each folder

    $global:PackageHelperModule = [ordered]@{
        Path                    = $global:PackageHelperModulePath

    }

    Write-Verbose $global:PackageHelperModule.Path
    
}
