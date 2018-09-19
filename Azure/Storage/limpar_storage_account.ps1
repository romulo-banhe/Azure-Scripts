function Get-StorageContainer
{
    param
    (
        [string]$StorageAccountName
    )

    $StorageAccounts = Get-AzureRmStorageAccount

    $selectedStorageAccount = $StorageAccounts | where-object{$_.StorageAccountName -eq $StorageAccountName}
    $key1 = (Get-AzureRmStorageAccountKey -ResourceGroupName $selectedStorageAccount.ResourceGroupName -name $selectedStorageAccount.StorageAccountName)[0].value

    $storageContext = New-AzureStorageContext -StorageAccountName $selectedStorageAccount.StorageAccountName -StorageAccountKey $key1
    $storageContainer = Get-AzureStorageContainer -Context $storageContext
    $storageContainer
}

$storageaccountname = storageaccountname

#lista os containers em uma storage account
Get-StorageContainer -StorageAccountName $storageaccountname

#lista os blobs em cada container de uma storage account
foreach ($container in (Get-StorageContainer -StorageAccountName $storageaccountname)) { Get-AzureStorageBlob -Context $storageContext -Container $container.name}

#remove cada blob em cada container de uma storage account
foreach ($container in (Get-StorageContainer -StorageAccountName $storageaccountname)) { foreach ($blob in (Get-AzureStorageBlob -Context $storageContext -Container $container.name
)){Remove-AzureStorageBlob -Container $container.name -Blob $blob.name -Context 
$storageContext}}

#remove cada container de uma storage account
foreach ($container in (Get-StorageContainer -StorageAccountName $storageaccountname)) {remove-azureStorageContainer -Name $container.name -Context $storageContext}
