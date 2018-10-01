##############################################################
# Title: Create Peering Network Operator
# Version: 1.0
# Author: Carlos Oliveira
# Last Modified: 2018-10-01
# Description: This role allows the user to perform Network Peering related operations in a single active directory
# 
### How to use this Powershell
# 0. Open Azure Cloud Shell at https://shell.azure.com/
# 1. Select Powershell (Preview)
# 2. Import file peering-network-operator.json to /home/<yourname>/
# 3. go to your /home/ page using
# > cd $home
# 4. Create a folder called azure-templates and enter on it Use the following commands: 
# > mkdir azure-templates
# > cd azure-templates
# 5. Run the cmdlet below
##############################################################

New-AzureRmRoleDefinition -InputFile "peering-network-operator.json"
