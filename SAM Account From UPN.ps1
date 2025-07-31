# Requires: ActiveDirectory module
# Input: Full logon name (User Principal Name)

param (
    [Parameter(Mandatory = $true)]
    [string]$UserPrincipalName
)

# Import AD module if not already loaded
if (-not (Get-Module -Name ActiveDirectory)) {
    Import-Module ActiveDirectory
}

try {
    # Query AD for the user with the given UPN
    $user = Get-ADUser -Filter "UserPrincipalName -eq '$UserPrincipalName'" -Properties SamAccountName

    if ($user) {
        Write-Output "SAMAccountName (pre-Windows 2000 logon name) for '$UserPrincipalName' is: $($user.SamAccountName)"
    } else {
        Write-Warning "No user found with UserPrincipalName: $UserPrincipalName"
    }
}
catch {
    Write-Error "An error occurred: $_"
}
