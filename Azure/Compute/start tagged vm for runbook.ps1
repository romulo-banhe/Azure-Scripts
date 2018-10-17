param(
    [Parameter(Mandatory=$true)]
    [string] $hour
)

$connectionName = "AzureRunAsConnection" 
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         
    
    "Logging in to Azure..."
    Login-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 

}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

$VMs = Get-AzureRMVm | Where {$_.Tags.Keys -eq "starthour" -and $_.Tags.Values -eq $hour -or $_.Tags.Keys -eq "startsabhour" -and $_.Tags.Values -eq $hour -or $_.Tags.Keys -eq "startdomhour" -and $_.Tags.Values -eq $hour} | Select Name, ResourceGroupName, Tags
ForEach ($VM in $VMs)
{
    $VMStatus = get-azurermvm -name $Vm.name -Resourcegroupname $vm.resourcegroupname -status
    If ($VMstatus.Statuses[1].DisplayStatus = "VM deallocated"){
        Write-Output "Starting: $($VM.Name)"
        Start-AzureRMVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName
    }
}
