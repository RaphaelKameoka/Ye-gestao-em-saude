# Caminho do arquivo a ser modificado
$caminhoDoArquivo = ".env"

# Obtém o endereço IPv4 da máquina pela conexão Wi-Fi
$ipv4 = (Get-NetIPAddress | Where-Object { $_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -like '*Wi-Fi*' }).IPAddress

# Substitui o termo no arquivo pelo endereço IPv4
(Get-Content $caminhoDoArquivo) -replace 'MYIP', $ipv4 | Set-Content $caminhoDoArquivo

Write-Host "Substituição concluída."
