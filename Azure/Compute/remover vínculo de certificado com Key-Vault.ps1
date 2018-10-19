##########################################
# Criado por: Carlos Oliveira
# Melhorado por: Henrique Brisola
##########################################
#
foreach ($vm in Get-AzureRmVm){
    $vmProfile.OSProfile.Secrets = New-Object -TypeName "System.Collections.Generic.List[Microsoft.Azure.Management.Compute.Models.VaultSecretGroup]"
    Update-AzureRmVM -ResourceGroupName $vmProfile.ResourceGroupName -VM $vm -Debug
}