$privilegedGroups = "Enterprise Admins","Domain Admins","Schema Admins","Administrators","Account Operators","Backup Operators","Print Operators","Server Operators","Domain Controllers","Read-only Domain Controllers","Group Policy Creator Owners","Cryptographic Operators","Distributed COM Users"
$privlegedExchangeGroups = "Exchange Windows Permissions","Exchange Trusted Subsystem","Organization Management","View-Only Organization Management","Recipient Management","UM Management","Help Desk","Hygiene Management","Records Management","Discovery Management","Public Folder Management","Server Management","Delegated Setup","Compliance Management"

$isExchangeEnabled = [System.Convert]::ToBoolean([int](Read-Host "Is AD Schema Extended for Exchange Server? (Enter 0 for no or 1 for yes)"))

$groupsToCheck = if ( $isExchangeEnabled ) { $privilegedGroups + $privlegedExchangeGroups } else { $privilegedGroups }

$groupsToCheck | foreach {
    $currentGroup = Get-ADGroup -Identity $_
    $currentMembership = Get-ADGroupMember -Identity $_

    $currentMembership | foreach {    
        $privilege = New-Object -TypeName PSObject
        Add-Member -InputObject $privilege -MemberType NoteProperty -Name "Group" -Value $currentGroup.DistinguishedName
        Add-Member -InputObject $privilege -MemberType NoteProperty -Name "GroupDisplayName" -Value $currentGroup.Name
        Add-Member -InputObject $privilege -MemberType NoteProperty -Name "Member" -Value $_.DistinguishedName
        Add-Member -InputObject $privilege -MemberType NoteProperty -Name "MemberUPN" -Value $_.SamAccountName
        Add-Member -InputObject $privilege -MemberType NoteProperty -Name "MemberDisplayName" -Value $_.Name
        
        $privilege
    }
} | Export-Csv "$($ENV:USERPROFILE)\Desktop\ADPrivilegedGroupCurrentMembership.csv"