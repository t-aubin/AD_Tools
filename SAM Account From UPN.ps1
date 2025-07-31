# Email-to-SAMAccountName.ps1
# Input: List of UPNs (emails)
# Output: UPN with corresponding SAMAccountName

function Get-SAMAccountNamesFromUPNs {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]]$UserPrincipalNames
    )

    begin {
        if (-not (Get-Module ActiveDirectory)) {
            Import-Module ActiveDirectory
        }
        $results = @()
    }

    process {
        foreach ($upn in $UserPrincipalNames) {
            $cleanUpn = $upn.Trim()
            if ($cleanUpn) {
                try {
                    $user = Get-ADUser -Filter "UserPrincipalName -eq '$cleanUpn'" -Properties SamAccountName
                    if ($user) {
                        $results += [PSCustomObject]@{
                            UserPrincipalName = $cleanUpn
                            SAMAccountName    = $user.SamAccountName
                        }
                    } else {
                        $results += [PSCustomObject]@{
                            UserPrincipalName = $cleanUpn
                            SAMAccountName    = "NOT FOUND"
                        }
                    }
                } catch {
                    Write-Warning "Error looking up $cleanUpn: $_"
                }
            }
        }
    }

    end {
        $results | Format-Table -AutoSize
    }
}
