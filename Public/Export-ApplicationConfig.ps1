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
    Get-ApplicationInfo -SearchTerm Git | Export-ApplicationConfig -FileType json
    
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