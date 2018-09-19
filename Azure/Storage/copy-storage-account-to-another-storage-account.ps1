$destSubscriptionId = '<SubscriptionId>'
$destStorageAccount = "<Dest Storage Account Name>"
$destStorageAccountKey = "<Private Key>"
$destStorageAccountContainer = "<Container Name>"

Select-AzureRmSubscription -SubscriptionId $destSubscriptionId
$destStorageAccountContext = New-AzureStorageContext –StorageAccountName $destStorageAccount -StorageAccountKey $destStorageAccountKey
Get-AzureStorageBlobCopyState -Context $destStorageAccountContext -Blob $targetSnapshotName
$blobCopy = Start-AzureStorageBlobCopy -DestContainer $destStorageAccountContainer -DestContext $destStorageAccountContext -SrcBlob $targetSnapshotName -Context $sourceStorageAccountContext -SrcContainer $sourceStorageAccountContainer
Write-Host ($blobCopy | Get-AzureStorageBlobCopyState).CopyId
Write-Host ($blobCopy | Get-AzureStorageBlobCopyState).TotalBytes
Write-Host ($blobCopy | Get-AzureStorageBlobCopyState).BytesCopied
while(($blobCopy | Get-AzureStorageBlobCopyState).Status -eq "Pending")
{
    Start-Sleep -s 5
    #$blobCopy | Get-AzureStorageBlobCopyState
    $output = "`r" + ($blobCopy | Get-AzureStorageBlobCopyState).BytesCopied
    Write-Host $output -NoNewline
}