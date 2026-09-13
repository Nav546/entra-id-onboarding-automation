# Offboard-Users.ps1
# Disables a user's account and removes them from all group memberships

$offboardList = @("Test User Five", "Test User Six")

foreach ($displayName in $offboardList) {

    Write-Host "Processing: $displayName" -ForegroundColor Cyan

    try {
        $user = Get-MgUser -Filter "DisplayName eq '$displayName'"

        if (-not $user) {
            Write-Host "  WARNING: User not found. Skipping." -ForegroundColor Yellow
            continue
        }

        # Disable the account
        Update-MgUser -UserId $user.Id -AccountEnabled:$false
        Write-Host "  Account disabled." -ForegroundColor Green

        # Find and remove from all group memberships
        $memberships = Get-MgUserMemberOf -UserId $user.Id

        foreach ($membership in $memberships) {
            Remove-MgGroupMemberByRef -GroupId $membership.Id -DirectoryObjectId $user.Id
            Write-Host "  Removed from group: $($membership.Id)" -ForegroundColor Green
        }

    }
    catch {
        Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}