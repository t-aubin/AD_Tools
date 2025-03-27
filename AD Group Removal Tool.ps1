#Removes list of user from an AD group

# Variables
$GroupName = "Your-AD-Group-Name"    # Replace with your AD group name
$EmailList = Get-Content "C:\Path\To\emails.txt"

# Get all domains in the forest
$domains = (Get-ADForest).Domains

foreach ($email in $EmailList) {
    $found = $false

    # Loop through each domain and search for the user
    foreach ($domain in $domains) {
        try {
            # Search in the current domain
            $user = Get-ADUser -Filter {EmailAddress -eq $email} -Server $domain -ErrorAction SilentlyContinue

            if ($user) {
                # Remove the user from the AD group
                Remove-ADGroupMember -Identity $GroupName -Members $user -Confirm:$false
                Write-Host "Removed $email ($($user.SamAccountName)) from $GroupName in $domain"
                $found = $true
                break  # Stop searching once the user is found
            }
        } catch {
            Write-Host "Error searching in $domain"
        }
    }

    if (-not $found) {
        Write-Host "User with email $email not found in any domain"
    }
}
