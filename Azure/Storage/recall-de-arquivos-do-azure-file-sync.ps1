Login-AzureRMSubscription
Select-AzureRmSubscription -SubscriptionId "<SubscriptionID>"
Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.ServerCmdlets.dll"
Invoke-StorageSyncFileRecall -Path "<Caminho físico do compartilhamento>"