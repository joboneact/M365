# CreatePlannerSampleTasks.ps1
# Thursday, May 22, 2025 1:38:14 PM  new bucket cmdlet fails, see end of script.🔴


# This script creates a new Microsoft Planner plan and adds sample tasks with overlapping dates.
# It checks if a plan with the same name exists in the group; if not, it creates the plan and adds the tasks.

# The script uses the Microsoft Graph PowerShell SDK to interact with Microsoft Planner.
# It requires the following permissions:
# - Group.ReadWrite.All: To read and write group information.
# - Tasks.ReadWrite: To read and write tasks in Microsoft Planner.
# The script creates a new plan in the specified Microsoft 365 group and adds sample tasks with random bucket, label, and category assignments. 
# It also includes error handling to ensure that the script does not overwrite existing plans.

# CHANGE LOG
# Thursday, May 22, 2025 1:38:14 PM  new bucket cmdlet fails, see end of script.🔴

# Requires Microsoft Graph PowerShell SDK
# Ensure you have the Microsoft Graph PowerShell SDK installed
# You can install it using the following command:
# Install-Module Microsoft.Graph -Scope CurrentUser
# Note: You may need to run PowerShell as an administrator to install the module.
# If you haven't installed the Microsoft Graph PowerShell SDK, uncomment the line below to install it.
# Uncomment the line below to install the Microsoft Graph PowerShell SDK
# Install-Module Microsoft.Graph -Scope CurrentUser
# Note: You may need to run PowerShell as an administrator to install the module.



# Install Microsoft Graph PowerShell module if not already installed
# You can uncomment the line below to install it.
# Install-Module Microsoft.Graph -Scope CurrentUser


# Import Microsoft.Graph module only if not already imported
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Import-Module Microsoft.Graph
    Write-Host "Microsoft.Graph module imported."
}

# # Check if the module is loaded
# if (-not (Get-Module -Name Microsoft.Graph)) {
#     Write-Error "Microsoft.Graph module is not loaded. Please install it first."
#     exit
# }


# CATCH 22
# this has to be here and the Get-MgGraphConnection relies on it - so Get cannot really occur
Connect-MgGraph -Scopes "Group.ReadWrite.All","Tasks.ReadWrite"

# Connect to Microsoft Graph interactively
# You can use the following command to connect interactively
# Connect-MgGraph -Scopes "Group.ReadWrite.All","Tasks.ReadWrite"
# If you have already connected, you can skip this step
# Check if already connected
if (-not (Get-MgGraphConnection)) {
    # Connect to Microsoft Graph interactively
    Connect-MgGraph -Scopes "Group.ReadWrite.All","Tasks.ReadWrite"
    Write-Host "Connected to Microsoft Graph." -ForegroundColor Green
}
else
{
    Write-Host "Already connected to Microsoft Graph." -ForegroundColor Yellow
}
# Check if the user has the required permissions
$permissions = Get-MgGraphConnection | Select-Object -ExpandProperty Scopes
$requiredPermissions = @("Group.ReadWrite.All", "Tasks.ReadWrite")
$missingPermissions = $requiredPermissions | Where-Object { $_ -notin $permissions }
if ($missingPermissions.Count -eq 0) { 

    

    # If the user does not have the required permissions, display an error message
    Write-Host "You do not have the required permissions to create Planner plans and tasks." -ForegroundColor Red
    
    Write-Host "Missing required permissions:" -ForegroundColor Red
    Write-Error "Missing required permissions: $($missingPermissions -join ', ')"
    Write-Host "Please ensure you have the necessary permissions to create Planner plans and tasks." -ForegroundColor Red
    exit
}
else {  
    Write-Host "All required permissions are granted." -ForegroundColor Green
}

#Connect-MgGraph -Scopes "Group.ReadWrite.All","Tasks.ReadWrite"



# Set variables
$groupName = "Contoso Project Team"
$groupName = "bartxo"
$planTitle = "Q3 Project Launch - Sample May 2025"

# Find the group
$group = Get-MgGroup -Filter "displayName eq '$groupName'"
if (-not $group) {
    Write-Error "Group '$groupName' not found."
    exit
}

# Check if the plan already exists
$existingPlan = Get-MgGroupPlannerPlan -GroupId $group.Id | Where-Object { $_.Title -eq $planTitle }
if ($existingPlan) {
    Write-Host "Planner plan '$planTitle' already exists in group '$groupName'. No changes made."
    exit
}

# Create the new plan
$newPlan = New-MgGroupPlannerPlan -GroupId $group.Id -Title $planTitle

# Sample users (replace with real user IDs from your tenant)
$users = @{
    "user-100" = "alice.johnson@contoso.com"
    "user-101" = "bob.smith@contoso.com"
    "user-102" = "carol.lee@contoso.com"
    "user-103" = "david.kim@contoso.com"
    "user-104" = "emma.white@contoso.com"
    "user-105" = "george.brown@contoso.com"
    "user-106" = "hannah.green@contoso.com"
    "user-107" = "ian.black@contoso.com"
    "user-108" = "julia.king@contoso.com"
    "user-109" = "kevin.scott@contoso.com"
    "user-110" = "laura.adams@contoso.com"
}

# Define five random bucket names
$buckets = @(
    "Planning & Kickoff",
    "Design & Prototyping",
    "Development",
    "Testing & QA",
    "Deployment & Support"
)

# Create buckets in the new plan and store their IDs
$bucketIds = @{}
foreach ($bucketName in $buckets) {
    $bucket = New-MgPlannerBucket -PlanId $newPlan.Id -Name $bucketName -OrderHint " !" 
    $bucketIds[$bucketName] = $bucket.Id
}

# Define nine random label names
$labels = @(
    "Urgent",
    "Client",
    "Internal",
    "Blocked",
    "In Progress",
    "Review",
    "Documentation",
    "Automation",
    "Follow Up"
)

# Helper function to randomly select labels for a task (1-3 labels per task)
function Get-RandomLabels {
    param([string[]]$labelNames)
    $count = Get-Random -Minimum 1 -Maximum 4
    $selected = Get-Random -InputObject $labelNames -Count $count
    return $selected
}

# Define task categories
$taskCategories = @(
    "Analysis",
    "Development",
    "Testing",
    "Deployment",
    "Support"
)

# Sample tasks with random bucket, label, and rotating category assignment
$tasks = @()
for ($i = 0; $i -lt 15; $i++) {
    $taskTitles = @(
        "Prepare project kickoff",
        "Design wireframes",
        "Review requirements",
        "Develop backend API",
        "Frontend integration",
        "QA test plan",
        "Security review",
        "Performance testing",
        "Documentation draft",
        "Stakeholder review",
        "Bug fixing sprint",
        "Final QA",
        "Release preparation",
        "Go-live",
        "Post-launch support"
    )
    $assignedToList = @(
        "user-100",
        "user-101,user-102",
        "user-103",
        "user-104",
        "user-105",
        "user-106",
        "user-107",
        "user-108",
        "user-109",
        "user-110",
        "user-101",
        "user-106",
        "user-110",
        "user-100",
        "user-103"
    )
    $dueDates = @(
        "2025-05-25","2025-05-28","2025-05-30","2025-06-02","2025-06-05",
        "2025-06-07","2025-06-04","2025-06-10","2025-06-08","2025-06-12",
        "2025-06-14","2025-06-16","2025-06-18","2025-06-20","2025-06-25"
    )
    $bucketIndex = $i % $buckets.Count
    $categoryIndex = $i % $taskCategories.Count
    $tasks += @{
        title      = $taskTitles[$i]
        assignedTo = $assignedToList[$i]
        dueDate    = $dueDates[$i]
        bucketName = $buckets[$bucketIndex]
        labels     = Get-RandomLabels $labels
        category   = $taskCategories[$categoryIndex]
    }
}

# Create tasks in the new plan
foreach ($task in $tasks) {
    $assignees = @{}
    foreach ($uid in $task.assignedTo -split ",") {
        $userEmail = $users[$uid]
        $userObj = Get-MgUser -Filter "mail eq '$userEmail'"
        if ($userObj) {
            $assignees[$userObj.Id] = @{}
        }
    }

    # Prepare label assignments (Planner supports up to 25 labels per plan, named label1-label25)
    $labelAssignments = @{}
    foreach ($label in $task.labels) {
        $labelIndex = [array]::IndexOf($labels, $label) + 1
        $labelAssignments["label$labelIndex"] = $true
    }

    # Add category as a checklist item (since Planner does not have a native "category" field)
    $checklist = @{
        ($task.category) = @{
            "title" = $task.category
            "isChecked" = $false
        }
    }

    New-MgPlannerTask -PlanId $newPlan.Id `
        -Title $task.title `
        -Assignments $assignees `
        -BucketId $bucketIds[$task.bucketName] `
        -DueDateTime ("{0}T17:00:00Z" -f $task.dueDate) `
        -AppliedCategories $labelAssignments `
        -Checklist $checklist
}

Write-Host "Planner plan '$planTitle' and tasks with categories created in group '$groupName'."

<#

add Task categories and add category to each task in rotation.

PS C:\Davis\Projects\M365\Power BI> gmo

ModuleType Version    Name                                ExportedCommands
---------- -------    ----                                ----------------
Script     1.0        GroupSet                            {BuildResourceCommonPar... 
Script     2.28.0     Microsoft.Graph.Authentication      {Add-MgEnvironment, Con... 
Script     2.28.0     Microsoft.Graph.Groups              {Add-MgGroupFavorite, A... 
Script     2.28.0     Microsoft.Graph.Planner             {Get-MgGroupPlanner, Ge...
Script     2.28.0     Microsoft.Graph.Users               {Get-MgUser, Get-MgUser... 
Manifest   3.1.0.0    Microsoft.PowerShell.Management     {Add-Computer, Add-Cont... 
Manifest   3.0.0.0    Microsoft.PowerShell.Security       {ConvertFrom-SecureStri... 
Manifest   3.1.0.0    Microsoft.PowerShell.Utility        {Add-Member, Add-Type, ... 
Script     0.2.0      PowerShellEditorServices.Commands   {Clear-Host, ConvertFro...
Script     2025.2.0   PowerShellProTools                  {ConvertTo-WinForm, Mer... 
Script     2024.12.0  PowerShellProTools.VSCode           {Add-VSCodeTextDocument... 
Script     1.0        ProcessSet                          {BuildResourceCommonPar... 
Manifest   1.1        PSDesiredStateConfiguration         {Invoke-DscResource, Pu... 
Script     2.4.0      PSReadLine                          {Get-PSReadLineKeyHandl... 
Script     1.0        ServiceSet                          {BuildResourceCommonPar... 
Script     1.0        WindowsFeatureSet                   {BuildResourceCommonPar... 
Script     1.0        WindowsOptionalFeatureSet           {BuildResourceCommonPar... 


PS C:\Davis\Projects\M365\Power BI>
PS C:\Davis\Projects\M365\Power BI> 

#>


<#

create new Powershell version of same sample Planner plan data. Write out to a Microsoft Planner plan but don't overwrite.

Here is a PowerShell script that creates a new Microsoft Planner plan and adds a dozen sample tasks with overlapping dates, without overwriting existing plans. This script uses the Microsoft Graph PowerShell SDK. It first checks if a plan with the same name exists in the group; if not, it creates the plan and adds the tasks.


Notes:

Replace the $groupName with your actual Microsoft 365 group name.
The $users hash table maps your sample user IDs to real user emails. Update these to match your tenant.
The script checks for an existing plan with the same title and does not overwrite if found.
You must have the necessary permissions and the Microsoft Graph PowerShell module installed.
This script creates tasks with overlapping due dates as in your sample data.



Add five random bucket names assign all tasks to one of five.
add 9 label names and randomly assign to each sample task.

#>


<#

Errors
Thursday, May 22, 2025 1:38:14 PM 


PS C:\Davis\Projects\M365\Power BI>
New-MgPlannerBucket : Schema validation has failed. Validation for field 'PlanId', 
on entity 'Bucket' has failed: The specified identifier is invalid.
Status: 400 (BadRequest)
ErrorCode: 
Date: 2025-05-22T17:37:30
Headers:
Transfer-Encoding             : chunked
Vary                          : Accept-Encoding
Strict-Transport-Security     : max-age=31536000
request-id                    : 12163b88-508c-43cc-aedf-c31f2e5a53cb
client-request-id             : 19fc0f54-9401-41ae-b3cc-a8365b7cc246
x-ms-ags-diagnostic           : {"ServerInfo":{"DataCenter":"East 
US","Slice":"E","Ring":"5","ScaleUnit":"002","RoleInstance":"BL02EPF000028A4"}}      
X-ProxyCluster                : wus-001.tasks.osi.office.net
X-OfficeCluster               : wus-001.tasks.osi.office.net
X-Tasks-CorrelationId         : 2b8d2b26-68f9-4473-9701-142b432c9b55
Cache-Control                 : no-cache
Date                          : Thu, 22 May 2025 17:37:30 GMT
At C:\Davis\Projects\M365\Power BI\CreatePlannerSampleTasks.ps1:127 char:5
+     $bucket = New-MgPlannerBucket -PlanId $newPlan.Id -Name $bucketNa ...
+     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidOperation: ({ Headers = , b...PlannerBucket }:  
   <>f__AnonymousType15`2) [New-MgPlannerBucket_CreateExpanded], Exception
    + FullyQualifiedErrorId : Microsoft.Graph.PowerShell.Cmdlets.NewMgPlannerBucket  
   _CreateExpanded
PS C:\Davis\Projects\M365\Power BI> 

#>