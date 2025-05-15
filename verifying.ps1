# Caminho para o arquivo de log
$LogFile = "C:\Logs\inactive_processes.log"

# Cria o arquivo de log se não existir
if (-Not (Test-Path $LogFile)) { 
    New-Item -Path $LogFile -ItemType File -Force | Out-Null
}

while ($true) {
    Write-Output "Verificando processos inativos..."
    Add-Content -Path $LogFile -Value "$(Get-Date): Iniciando verificação de processos inativos..."

    # Identifica e finaliza processos inativos
    Get-Process | Where-Object { $_.Responding -eq $false } | ForEach-Object {
        # Obtém as informações do processo
        $ProcessId = $_.Id
        $ProcessName = $_.ProcessName

        # Log do processo identificado
        $logEntry = "$(Get-Date): Processo inativo identificado - PID: $ProcessId, Nome: $ProcessName"
        Write-Output $logEntry
        Add-Content -Path $LogFile -Value $logEntry

        try {
            # Tenta finalizar o processo
            Stop-Process -Id $ProcessId -Force -ErrorAction Stop
            $logSuccess = "$(Get-Date): Processo finalizado com sucesso - PID: $ProcessId, Nome: $ProcessName"
            Write-Output $logSuccess
            Add-Content -Path $LogFile -Value $logSuccess
        } catch {
            # Caso ocorra um erro ao finalizar o processo
            $logError = "$(Get-Date): Erro ao finalizar processo - PID: $ProcessId, Nome: $ProcessName. Detalhes: $($_.Exception.Message)"
            Write-Output $logError
            Add-Content -Path $LogFile -Value $logError
        }
    }

    # Espera 60 segundos antes de executar novamente
    Start-Sleep -Seconds 60
}
