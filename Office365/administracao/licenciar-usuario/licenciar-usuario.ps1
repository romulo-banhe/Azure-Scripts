$cred=Get-Credential
$dominio="Dominio do cliente"
$cliente=(Get-MsolPartnerContract -DomainName $dominio).TenantId
Connect-MsolService -Credential $cred
Import-Csv -Path "Caminho do CSV" | ForEach-Object {
    New-MsolUser -UserPrincipalName $_.UserPrincipalName -FirstName $_.FirstName -LastName $_.LastName -DisplayName $_.DisplayName -PhoneNumber $_.Fixo -MobilePhone $_.Movel -City $_.Cidade -State $_.Estado -StreetAddress $_.Endereco -LicenseAssignment $_.Licenca -Password $_.Senha -PasswordNeverExpires $_.Expiracao -Country $_.Country -Department $_.Departamento -Office $_.Escritorio -Title $_.Cargo -UsageLocation $_.Pais -TenantId $cliente
}