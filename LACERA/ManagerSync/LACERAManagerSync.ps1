$OUPath = ""

function ManagerLookup
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  PositionalBinding=$false,
                  HelpUri = 'https://aka.ms/jrm',
                  ConfirmImpact='Medium')]
    [Alias("Manager")]
    [OutputType([string])]
    Param
    (
        # Switch indicating that execution is running on the County side
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [switch]$County,

        # Switch indicating that execution is running on the LACERA side
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [switch]$LACERA,
        
        # If Input is DN, Output will be Employee ID
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [Alias("Identity")]
        [Alias("DN")]
        $DistinguishedName,

        # If Input is EmployeeID, Output will be DistinguishedName
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [Alias("Employee")]
        [Alias("ID")]
        $EmployeeID
    )

    Begin
    {
        # Validate Return Type
        if ( $County -and $LACERA ) { Write-Error "Input error: multiple sources of authority indicated"}

        $managerEmployeeID = $EmployeeID.Replace('c','')
        $managerEmployeeID = $managerEmployeeID.Replace('e','')
        Write-Host "Resolving DistinguishedName of Employee $($managerEmployeeID)"
    }
    Process
    {
        # Retrieve User Object and Store Output
        if ( $County )
        {
            $userObject = Get-ADUser -Identity $DistinguishedName -Properties "EmployeeID"
            [string]$output = $($userObject.EmployeeID)
        } elseif ( $LACERA )
        {
            $userObject = Get-ADUser -Filter * -Properties "DistinguishedName","EmployeeID" | Where-Object -Property EmployeeID -EQ $managerEmployeeID
            [string]$output = $($userObject.DistinguishedName)
        } else {
            Write-Error "Invalid Input, Unknown Source of Authority"
            break
        }

        if ( ! $userObject ) 
        { 
            Write-Error "User Object Not Found"
            break
        }
    }
    End
    {
        Write-Host "Returned Data: $($output)"
        return $output
    }
}

function StoreManager
{
    [CmdletBinding(DefaultParameterSetName='Parameter Set 1', 
                  SupportsShouldProcess=$true, 
                  PositionalBinding=$false,
                  HelpUri = 'http://www.microsoft.com/',
                  ConfirmImpact='Medium')]
    [Alias()]
    [OutputType()]
    Param
    (
        # Switch indicating that execution is running on the County side
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [switch]$County,

        # Switch indicating that execution is running on the LACERA side
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [switch]$LACERA,
        
        # UPN of User for whom Manager should be stored
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        $UserPrincipalName,

        # If Input is DistinguishedName, Manager will be referenced from ExtensionAttribute10 and stored in the Manager attribute
        [Parameter(Mandatory=$false, 
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true, 
                   ValueFromRemainingArguments=$false, 
                   Position=0,
                   ParameterSetName='Parameter Set 1')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Alias("DN")]
        [Alias("Manager")]
        $DistinguishedName,

        # If Input is EmployeeID, Manager will be referenced from the Manager attribute and stored in the ExtensionAttribute10 
        [Parameter(ParameterSetName='Parameter Set 1')]
        [AllowNull()]
        [AllowEmptyCollection()]
        [AllowEmptyString()]
        [Alias("ManagerID")]
        [Alias("EID")]
        $EmployeeID
    )

    Begin
    {
        # Validate Return Type
        if ( $County -and $LACERA ) { Write-Error "Input error: multiple sources of authority indicated"}

        # Get User Object for Processing
        $userToUpdate = Get-ADUser -Filter * -SearchBase $OUPath -Properties ExtensionAttribute10,Manager | Where-Object -Property UserPrincipalName -EQ $UserPrincipalName
    }
    Process
    {
        if ($pscmdlet.ShouldProcess("Target", "Operation"))
        {
            if ( $County )
            {
                $userObject = Set-ADUser -Identity $($userToUpdate.DistinguishedName) -Add @{ExtensionAttribute10 = "$($EmployeeID)"} -PassThru
            } elseif ( $LACERA )
            {
                $userObject = Set-ADUser -Identity $($userToUpdate.DistinguishedName) -Manager $DistinguishedName -PassThru
            } else {
                Write-Error "Invalid Input, Unknown Source of Authority"
                break
            }

            if ( ! $userObject ) 
            { 
                Write-Error "User Object Not Found"
                break
            }
        }
    }
    End
    {
        return $userObject
    }
}

$users = Get-ADUser -Filter * -SearchBase $OUPath -Properties Manager,ExtensionAttribute10 # | Where-Object -Property UserPrincipalName -EQ 'user@lacera.com'
[stringp[]]$failedUPN = $null
$users | ForEach-Object {
    if ( $_.ExtensionAttribute10 ) {
        Write-Host "Resolving Manager ID Number $($_.ExtensionAttribute10) for user $($_.UserPrincipalName)"
        StoreManager -LACERA -UserPrincipalName $($_.UserPrincipalName) -Manager ( ManagerLookup -LACERA -EmployeeID $($_.ExtensionAttribute10) )
    } else {
        Write-Error "$($_.UserPrincipalName) does not have a Manager synced from LA County records."
        Write-Warning "Skipping user $($_.UserPrincipalName)"
        $failedUPN += $($_.UserPrincipalName)
    }
}

$failedUPN | Out-File -FilePath $env:ProgramData\LACERAManagerSync.log -Append