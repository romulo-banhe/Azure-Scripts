#util para identificar discos SSD e sua possibilidade de alteração em HDD para redução de custos
$vms = get-azurermvm
$lines = @()
foreach ($vm in $vms) {
	$osdisk = get-azurermdisk -name $vm.storageprofile.osdisk.name;
	foreach ($disk in $osdisk) {
		$lines += New-Object PsObject -Property @{
			"disk.name"	= "$($disk.name)";
			"disksizegb"	= "$($disk.disksizegb)";
			"sku.name"	= "$($disk.sku.name)";
			"managedby"	= "$($disk.managedby)";
		}
	}
}
