##############################################################
# Title: Register Azure File Sync 
# Version: 1.0
# Author: Carlos Oliveira
# Last Modified: 2018-09-10
#
##############################################################
Import-Module "C:\Program Files\Azure\StorageSyncAgent\StorageSync.Management.PowerShell.Cmdlets.dll"
$subscriptionId="<your subscription ID Here>"
$tenantId="<your tenant ID here>"
$resourceGroupName="<your Resource Group Name Here"
$storageSyncServiceName="<Your Azure File Sync resource Name>"
Login-AzureRmStorageSync -SubscriptionID $subscriptionId -TenantID $tenantId
Register-AzureRmStorageSyncServer -SubscriptionId $subscriptionId - ResourceGroupName $resourceGroupName - StorageSyncService $storageSyncServiceName