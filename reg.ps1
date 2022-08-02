Clear-Host

# Refactor to get all Autorun details
Function Get-AutorunDetail 
{
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
    'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run',
    'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce' | 
    ForEach-Object {(Get-Item -Path $PSitem).Property}
}

Get-AutorunDetail | 
Out-Null

Function Write-AutorunResultsFile
{
    # Check if file path exists
    $AutorunResultsFile = 'C:\Users\dkejd\OneDrive\바탕 화면\study\project\PC_Check'

    # If not, create the path and the new file
    if ( -not (Test-Path -Path "$AutorunResultsFile\AutorunResultsFile.txt")) 
    {
        New-Item -Path $AutorunResultsFile -ItemType File -Name 'AutorunResultsFile.txt' -Force | 
        Out-Null

        # Add the Autorun detail to the new file
        Get-AutorunDetail | 
        ForEach-Object {Add-Content -Path "$AutorunResultsFile\AutorunResultsFile.txt" -Value $PSitem}
    }
    else 
    {
        if ($AutorunDetails = (Compare-Object -ReferenceObject (Get-AutorunDetail) -DifferenceObject (Get-Content -Path "$AutorunResultsFile\AutorunResultsFile.txt")) -match '<=')
        {
            Add-Content -Path "$AutorunResultsFile\AutorunResultsFile.txt" -Value 'New process detected.'
            Add-Content -Path "$AutorunResultsFile\AutorunResultsFile.txt" -Value ($AutorunDetails.InputObject | Select-Object -Last 1)
        }
        else 
        {Add-Content -Path "$AutorunResultsFile\AutorunResultsFile.txt" -Value 'No new process detected.'}
    }
}

Write-AutorunResultsFile