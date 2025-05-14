$UserName = "adminlopes"
$Password = "Serv2008" | ConvertTo-SecureString -AsPlainText -Force

if (-Not (Get-LocalUser -Name $UserName -ErrorAction SilentlyContinue)) {
    New-LocalUser -Name $UserName -Password $Password -FullName "Administrador Local" -Description "Usuário criado via GPO" -PasswordNeverExpires -AccountNeverExpires
    Add-LocalGroupMember -Group "Administradores" -Member $UserName
} else {
    Write-Output "Usuário $UserName já existe. Nenhuma ação realizada."
}
