param(
    [Parameter(Mandatory=$true)]
    [string] $hour
)
$storageType = 'Premium_LRS'  # Premium_LRS, StandardSSD_LRS, Standard_LRS

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

$VMs = Get-AzureRMVm | Where {$_.Tags.Keys -eq "starthour" -and $_.Tags.Values -eq $hour -or $_.Tags.Keys -eq "startsabhour" -and $_.Tags.Values -eq $hour -or $_.Tags.Keys -eq "startdomhour" -and $_.Tags.Values -eq $hour}
ForEach ($VM in $VMs)
{
    $osdisk = $vm.storageprofile.osdisk.name
    $diskUpdateConfig = New-AzureRmDiskUpdateConfig -AccountType $storageType 
    Write-Output "Converting: $($osdisk) to $($storageType)"
    Update-AzureRmDisk -DiskUpdate $diskUpdateConfig -ResourceGroupName $vm.ResourceGroupName `
    -DiskName $osdisk

    $datadisks = $vm.StorageProfile.DataDisks
    foreach ($disk in $datadisks){
        $diskUpdateConfig = New-AzureRmDiskUpdateConfig -AccountType $storageType 
        Write-Output "Converting: $($disk.Name) to $($storageType)"
        Update-AzureRmDisk -DiskUpdate $diskUpdateConfig -ResourceGroupName $vm.ResourceGroupName `
        -DiskName $disk.Name
    }
    $VMStatus = get-azurermvm -name $Vm.name -Resourcegroupname $vm.resourcegroupname -status
    If ($VMstatus.Statuses[1].DisplayStatus = "VM deallocated"){
        Write-Output "Starting: $($VM.Name)"
        Start-AzureRMVM -Name $VM.Name -ResourceGroupName $VM.ResourceGroupName
    }
}
