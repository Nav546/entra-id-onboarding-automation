# Onboard-Users.ps1
# Reads new hires from a CSV, creates them in Entra ID, and adds them to their department group

$csvPath = "C:\Temp\newhires.csv"
$newHires = Import-Csv -Path $csvPath

foreach ($hire in $newHires) {

    Write-Host "Processing: $($hire.DisplayName)" -ForegroundColor Cyan

    try {
        $PasswordProfile = @{
            Password = "TempPass123!"
            ForceChangePasswordNextSignIn = $true
        }

        $newUser = New-MgUser -DisplayName $hire.DisplayName `
            -UserPrincipalName $hire.UserPrincipalName `
            -AccountEnabled `
            -MailNickname $hire.MailNickname `
            -PasswordProfile $PasswordProfile `
            -Department $hire.Department

        Write-Host "  User created." -ForegroundColor Green

        # Look up the department group and add the new user to it
        $deptGroup = Get-MgGroup -Filter "DisplayName eq '$($hire.Department)'"

        if ($deptGroup) {
            New-MgGroupMember -GroupId $deptGroup.Id -DirectoryObjectId $newUser.Id
            Write-Host "  Added to group: $($hire.Department)" -ForegroundColor Green
        }
        else {
            Write-Host "  WARNING: No group found named '$($hire.Department)'. Skipping group assignment." -ForegroundColor Yellow
        }

    }
    catch {
        Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
    }
}