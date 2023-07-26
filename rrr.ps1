# set-alias -name rrr -value "E:\Users\amramedworkin\source\repos\azuretest\myswa\rrr.ps1"
# Get all processes containing "npx swa" or "swa" in their names
$processes = Get-Process | Where-Object { $_.Name -like "*npx swa*" -or $_.Name -like "*swa*" }
$processes
# Terminate each process
$processes | ForEach-Object {
    try {
        $_.Kill()
        Write-Host "Process with ID $($_.Id) and Name $($_.Name) terminated."
    } catch {
        Write-Host "Failed to terminate process with ID $($_.Id) and Name $($_.Name)."
    }
}

# Verify if the processes were terminated
$terminatedProcesses = Get-Process | Where-Object { $_.Name -like "*npx swa*" -or $_.Name -like "*swa*" }

if ($terminatedProcesses.Count -eq 0) {
    Write-Host "All npx swa and swa processes have been terminated."
} else {
    Write-Host "Some npx swa and/or swa processes could not be terminated."
    exit
}
# Get the full path of the swa.txt file in the current directory
$swaTxtFile = Join-Path -Path $PSScriptRoot -ChildPath "swa.txt"

# Check if the file exists before attempting to delete it
if (Test-Path -Path $swaTxtFile) {
    # Delete the swa.txt file
    try {
        Remove-Item -Path $swaTxtFile -Force
        Write-Host "swa.txt has been deleted successfully."
    } catch {
        Write-Host "Failed to delete swa.txt: $_"
    }
} else {
    Write-Host "swa.txt does not exist in the current directory."
}


$swaOutputFile = "swa.txt"
$currentDirectory = Get-Location

# Ensure the SWA output file is deleted if it already exists
if (Test-Path -Path $swaOutputFile) {
    Remove-Item -Path $swaOutputFile -Force
}

# Change directory to the currently executing folder
Set-Location $currentDirectory

Start-Process npx -ArgumentList "swa start --verbose silly" -NoNewWindow -RedirectStandardOutput $swaOutputFile -Wait

# Change back to the original directory
Set-Location $currentDirectory
