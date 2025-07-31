# Requires: ActiveDirectory module
# Input: A list of UPNs (pasted into the console or piped from a file)

function Get-SAMAccountNamesFromUPNs {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]]$UserPrincipalNames
    )

    # Import AD module if not already loaded
    if (-not (Get-Module -Name ActiveDirectory)) {
        Import-Module ActiveDirectory
    }

    process {
        foreach ($upn in $UserPrincipalNames) {
            $upn = $upn.Trim()
            if ($upn) {
                try {
                    $user = Get-ADUser -Filter "UserPrincipalName -eq '$upn'" -Properties SamAccountName
                    if ($user) {
                        [PSCustomObject]@{
                            UserPrincipalName = $upn
                            SAMAccountName    = $user.SamAccountName
                        }
                    } else {
                        [PSCustomObject]@{
                            UserPrincipalName = $upn
                            SAMAccountName    = "NOT FOUND"
                        }
                    }
                } catch {
                    Write-Warning "Error querying UPN '$upn': $_"
                }
            }
        }
    }
}

# Example usage: manually pasted list
@(
    "jane.doe@yourdomain.com"
    "john.smith@yourdomain.com"
    "missing.user@yourdomain.com"
) | Get-SAMAccountNamesFromUPNs | Format-Table -AutoSize
