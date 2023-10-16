Param($TenantId, $Location)

(Get-Content ./assets/mg-structure.json) -replace '""', "`"$tenantId`"" | Set-Content ./assets/mg-structure.json

./assets/deploy-ManagementGroupStructure.ps1 -TenantId $TenantId -Location $Location

$gs = @"
{
    "pacOwnerId": "4f5222f0-6677-4987-8de6-6fbc97ab631f",
    "managedIdentityLocations": {
        "*": "$Location"
    },
    "globalNotScopes": {
        "*": [
            "/resourceGroupPatterns/excluded-rg*"
        ]
    },
    "pacEnvironments": [
        {
            "pacSelector": "slz",
            "cloud": "AzureCloud",
            "tenantId": "$tenantId",
            "deploymentRootScope": "/providers/Microsoft.Management/managementGroups/slz"
        }
    ]
}
"@

New-EPACDefinitionFolder -DefinitionsRootFolder Definitions
New-EPACDefinitionFolder -DefinitionsRootFolder Cleanup

$gs | Out-File ./Definitions/global-settings.jsonc
$gs | Out-File ./Cleanup/global-settings.jsonc

git clone https://github.com/Azure/sovereign-landing-zone.git tmp

Copy-Item ./assets/sovereignLandingZone.parameters.json ./tmp/orchestration/scripts/parameters/sovereignLandingZone.parameters.json -Verbose -Force
Copy-Item ./assets/New-Compliance.ps1 ./tmp/orchestration/scripts/New-Compliance.ps1 -Verbose -Force
Push-Location
cd ./tmp/orchestration/scripts

./New-SovereignLandingZone.ps1 -parDeployment compliance -parAttendedLogin $false

Start-Sleep -Seconds 180

Pop-Location

Remove-Item -Path tmp -Recurse -Force

Export-AzPolicyResources -DefinitionsRootFolder ./Definitions -OutputFolder Output

Copy-Item ./Output/Definitions/policySetDefinitions ./Definitions -Force -Recurse
Copy-Item ./Output/Definitions/policyAssignments ./Definitions -Force -Recurse

Build-DeploymentPlans -DefinitionsRootFolder ./Cleanup -OutputFolder Output
Deploy-PolicyPlan -DefinitionsRootFolder ./Cleanup -InputFolder Output
Deploy-RolesPlan -DefinitionsRootFolder ./Cleanup -InputFolder Output

Remove-Item -Path Output -Recurse -Force
Remove-Item -Path Cleanup -Recurse -Force

Remove-Item -Path ./Definitions/global-settings.jsonc -Force





