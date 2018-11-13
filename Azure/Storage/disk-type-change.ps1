$storageType = 'Standard_LRS'  # Premium_LRS, StandardSSD_LRS, Standard_LRS

foreach ($vm in $vms) {
    $osdisk = $vm.storageprofile.osdisk.name
    $diskUpdateConfig = New-AzureRmDiskUpdateConfig -AccountType $storageType 
    Update-AzureRmDisk -DiskUpdate $diskUpdateConfig -ResourceGroupName $vm.ResourceGroupName `
    -DiskName $osdisk

    $datadisks = $vm.StorageProfile.DataDisks
    foreach ($disk in $datadisks){
        $diskUpdateConfig = New-AzureRmDiskUpdateConfig -AccountType $storageType 
        Update-AzureRmDisk -DiskUpdate $diskUpdateConfig -ResourceGroupName $vm.ResourceGroupName `
        -DiskName $disk.Name
    }
}