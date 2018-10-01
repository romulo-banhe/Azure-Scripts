#Conectar a MS
Import-Module MSOnline
$Cred = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri "https://ps.outlook.com/powershell/" -Credential $Cred -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MsolService -Credential $Cred


#Para um usuário especifico:

$user_ol = Get-Mailbox "upn@sufixo" #login do usuario

#para todos os usuários:
#$user_ol = Get-MsolUser

$Pobox = "NOME DO BAIRRO" #Deixar a variavel vazia para não gravar conteudo na assinatura
$Street = "NOME DA RUA" #Deixar a variavel vazia para não gravar conteudo na assinatura
$City = "NOME DA CIDADE" #Deixar a variavel vazia para não gravar conteudo na assinatura
$State = "NOME DO ESTADO" #Deixar a variavel vazia para não gravar conteudo na assinatura
$Zipcode = "CEP DA RUA" #Deixar a variavel vazia para não gravar conteudo na assinatura



$Assinatura = Get-Content -Path "CAMINHA DO CÓDIGO HTML EM TXT"

foreach($users in ($user_ol)){
	
    #COLETA DOS ATRIBUTOS DO AD
	$DisplayN 		= $users.DisplayName
	$Departamento 	= $users.Department
	$Phone 			= $user.telephoneNumber
	$Fax 			= $user.facsimileTelephoneNumber
	$Street 		= $users.StreetAddress
	$Pobox 			= $users.POBox
	$City 			= $users.City
	$State 			= $users.State
	$Zipcode 		= $users.PostalCode
	
	
	$Assinatura = $Assinatura.Replace("DisplayName", $DisplayN)
	$Assinatura = $Assinatura.Replace("Departamento", $Departamento)
	$Assinatura = $Assinatura.Replace("Phone", $Phone)
	$Assinatura = $Assinatura.Replace("Fax", $Fax)
	$Assinatura = $Assinatura.Replace("Street", $Street)
	$Assinatura = $Assinatura.Replace("POBox", $Pobox)
	$Assinatura = $Assinatura.Replace("City", $City)
	$Assinatura = $Assinatura.Replace("State", $State)
	$Assinatura = $Assinatura.Replace("Zipcode", $Zipcode)
	Set-MailboxMessageConfiguration -Identity $user_ol.UserPrincipalName -AutoAddSignature $True -SignatureHtml $Assinatura
	Write-Host "Assinatura Configurada para o Usuario $DisplayN"
	sleep (5)
}


