#a connection to VPN is required for this script to run properly
#OneDrive must be enabled on the workstation

$HDrive = "H:"
$OneDrive = "C:\Users\$($env:USERNAME)\OneDrive - Government of BC"
$Logpath = "C:\Users\$($env:USERNAME)\OneDrive - Government of BC\Logs"
$date = "OneDriveMigration_$(Get-Date -format yyyyMMddHHmm)"

if (Test-Path -Path $OneDrive) {

    # Create folder if does not exist
    if (!(Test-Path -Path $Logpath))
    {
        $paramNewItem = @{
            Path      = $Logpath
            ItemType  = 'Directory'
            Force     = $true
        }

        New-Item @paramNewItem
    }

    Write-Host "This script is intended to help copy files from your H: to OneDrive, you must have a VPN connection and have OneDrive enabled/installed. Do you wish to proceed?" -NoNewline
    $confirmationcopy = Write-Host " [y/n] " -ForegroundColor Yellow -NoNewline
    $confirmationcopy = Read-Host

    if ($confirmationcopy -eq 'y') {
        Write-Host "Choose y if you wish to remove your data from the H: drive once it has been copied to OneDrive, or n if you intend to manually delete the data from H: at a later time."  -NoNewline
        $removedata = Write-Host " [y/n] " -ForegroundColor Yellow -NoNewline
        $removedata = Read-Host

        Write-Host "Be advised that this script will not move your .pst files due to concerns that they do not work well in Outlook when accessed from OneDrive" -ForegroundColor Red -BackgroundColor Black -NoNewline
    }

    if ($removedata -eq 'n') {
        Write-Host "The following file types will remain on the H: drive for ease of use: *.cfg *.ini *.one *.pst"
        Write-Host -ForegroundColor Green -BackgroundColor Black "`nCopying Data to OneDrive. This may take a few minutes...`n"
        robocopy $HDrive $OneDrive /V /log+:$logpath\log-$date.txt /E /Z /R:1 /W:1 /xf *.cfg *.ini *.one *.pst /xd "$HDrive\Profile" "$HDrive\WINDOWS" "$HDrive\CFGFiles" "$HDrive\DYMO" "$HDrive\DYMO Label" "$HDrive\TRIM" "$HDrive\TRIM Data" "$HDrive\My Received Files" "$HDrive\Remote Assistance Logs"
        if ($lastexitcode -gt 0)  {
            write-host "Robocopy exit code:" $lastexitcode
        }
        else {
            Write-Host -ForegroundColor White -BackgroundColor DarkBlue "Your H: drive contents have been copied to OneDrive. Verify the copy was successful, then review your H: Drive and manually remove any data already available in OneDrive at your earliest convenience. Please remember to empty your recycling bin following the cleanup" -NoNewline
        }}
    elseif ($removedata -eq 'y') {
        Write-Host "The following file types will remain on the H: drive for ease of use: *.cfg *.ini *.one *.pst"
        Write-Host -ForegroundColor Green -BackgroundColor Black "`nMoving Data to OneDrive. This may take a few minutes...`n"
        robocopy /MOVE /E /Z $HDrive $OneDrive /V /log+:$logpath\log-$date.txt /R:1 /W:1 /xf *.cfg *.ini *.one *.pst /xd "$HDrive\Profile" "$HDrive\WINDOWS" "$HDrive\CFGFiles" "$HDrive\DYMO" "$HDrive\DYMO Label" "$HDrive\TRIM" "$HDrive\TRIM Data" "$HDrive\My Received Files" "$HDrive\Remote Assistance Logs"
        if ($lastexitcode -gt 0)  {
            write-host "Robocopy exit code:" $lastexitcode
        }
        else {
            Write-Host -ForegroundColor White -BackgroundColor DarkBlue "Your H: drive contents have been moved to OneDrive."
        }}
}


Else { "Please enable OneDrive before running this script" }

# If running in the console, wait for input before closing.
if ($Host.Name -eq "ConsoleHost")
{
    Write-Host "Press any key to continue..."
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyUp") > $null
}