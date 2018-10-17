#prepare - you must have a credential json file, to create it export after selecting the desired subscription, this a one time step.
login-azurermaccount
$subscription=
select-azurermsubscription -subscription $subscription
export-AzureRmProfile -Path "D:\Google Drive\Cloud\Azure\credential.json"

#usage - use this command to login whithout prompt and then you can run any automated script
import-AzureRmProfile -Path "D:\Google Drive\Cloud\Azure\credential.json"
