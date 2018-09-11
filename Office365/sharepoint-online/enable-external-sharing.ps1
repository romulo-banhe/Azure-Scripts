##############################
# Habilitar Compartilhamento externo em sites de comunicação
#
# Autor: Carlos Oliveira
# Versão: 3.0
# Data de Modificação: 11/09/2018
#
# Para validar se o comando deu certo, utilize o comando
# > Get-SPOSite -Identity https://$orgName.sharepoint.com/sites/$siteName | Select-Object Title,Owner,SharingCapability
#
##############################
$cred=Get-Credential
$orgName="contoso"
Connect-SPOService -Url https://$orgName-admin.sharepoint.com -Credential $cred
$siteName="NomeDoSite"
Set-SPOSite -Identity https://$orgName.sharepoint.com/sites/$siteName -SharingCapability ExternalUserAndGuestSharing