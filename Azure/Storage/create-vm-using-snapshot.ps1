$rgName = "DestResourceGroup"
$location = "northeurope"
$storageName = "MyVMstorage"
$storageType = "Standard_LRS"
$nicname = "MyVM-nic"
$subnet1Name = "MyVM-subnet"
$vnetName = "MyVM-vnet"
$vnetAddressPrefix = "10.0.0.0/16"
$vnetSubnetAddressPrefix = "10.0.0.0/24"
$vmName = "MyVM"
$vmSize = "Standard_D2s_v3"
$osDiskName = $vmName + "osDisk"
$osDiskUri = "https://$destStorageAccount.blob.core.windows.net/$sourceStorageAccountContainer/$targetSnapshotName"

$storageacc = New-AzureRmStorageAccount -ResourceGroupName $rgName -Name $storageName -Type $storageType -Location $location
$pip = New-AzureRmPublicIpAddress -Name $nicname -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic
$subnetconfig = New-AzureRmVirtualNetworkSubnetConfig -Name $subnet1Name -AddressPrefix $vnetSubnetAddressPrefix
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix $vnetAddressPrefix -Subnet $subnetconfig
$nic = New-AzureRmNetworkInterface -Name $nicname -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id
$vm = New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize
$vm = Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id

$discStorageAcc = Get-AzureRmStorageAccount -ResourceGroupName $ResourceGroup -Name $destStorageAccount
$diskConfig = New-AzureRmDiskConfig -AccountType 'PremiumLRS' -Location $location -CreateOption Import -StorageAccountId ($discStorageAcc.Id) -SourceUri $osDiskUri
$disk = New-AzureRmDisk -Disk $diskConfig -ResourceGroupName $rgName -DiskName "managedsnapshot"
$vm = Set-AzureRmVMOSDisk -VM $vm -ManagedDiskId $disk.Id -CreateOption Attach -Windows

New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $vm -Verbose