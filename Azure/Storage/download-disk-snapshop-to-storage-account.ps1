$sourceSubscriptionId = '<SubscriptionId>'
$sourceStorageAccountName = "<Source Storae Account>"
$sourceStorageAccountKey = "<Private Key>"
$sourceStorageAccountContainer = "<Container Name>"
$container = 

# path of the download URL of the snapshot
$VHDDownloadUri = conc "https://$sourceStorageAccountName.blob.core.windows.net/$sourceStorageAccountContainer"
$targetSnapshotName = "<SnapshotName>.vhd"

#download snapshot to StorageAccount-Source (the storage account is located in the source subscription)
Select-AzureRmSubscription -SubscriptionId $sourceSubscriptionId
$sourceStorageAccountContext = New-AzureStorageContext –StorageAccountName $sourceStorageAccountName -StorageAccountKey $sourceStorageAccountKey
Start-AzureStorageBlobCopy -AbsoluteUri $VHDDownloadUri -DestContainer $sourceStorageAccountContainer -DestContext $sourceStorageAccountContext -DestBlob $targetSnapshotName