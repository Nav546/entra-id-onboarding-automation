**\# Entra ID Onboarding \& Offboarding Automation**



PowerShell scripts that automate the user lifecycle in Microsoft Entra ID using the Microsoft Graph SDK turning manual identity admin into a repeatable, scriptable process.



**\## The Problem**



Manually creating and disabling user accounts, assigning them to the right groups, and cleaning up access when someone leaves is slow and error-prone at any scale beyond a handful of people. This project automates that lifecycle end-to-end.



**\## What It Does**



**\*\*Onboard-Users.ps1\*\***

\- Reads a list of new hires from a CSV file (name, email, department)

\- Creates each user in Entra ID with a temporary password (forced change on first login)

\- Automatically adds each user to their department's security group

\- Logs a warning (without failing the batch) if no matching group exists



**\*\*Offboard-Users.ps1\*\***

\- Disables the user's account immediately

\- Looks up every group the user belongs to

\- Removes them from all group memberships, so no residual access remains



**\## Tech Used**



\- PowerShell 7

\- Microsoft Graph PowerShell SDK (`Microsoft.Graph.Authentication`, `Microsoft.Graph.Users`, `Microsoft.Graph.Groups`)

\- Microsoft Entra ID (tested on a free-tier tenant)



**\## Example**



.\\Onboard-Users.ps1

\# Processing: Test User Five

\#   User created.

\#   Added to group: IT



**\## What's Next**



\- Make offboarding CSV-driven, matching the onboarding pattern

\- Add persistent logging to a file for audit trail

\- Add license assignment for tenants with paid SKUs

