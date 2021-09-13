# Active Directory Scripts and Tools
## ADPrivilegedGroupMembershipAudit.ps1
This script discovers and audits membership of all privileged groups; including Exchange groups if the AD Schema has been extended for the same.  
Exports data to a CSV on the current user's desktop.  Must be run by a Domain Admin, required ActiveDirectory Module for Windows PowerShell to be installed but does not need to be run on a Domain Controller directly.
