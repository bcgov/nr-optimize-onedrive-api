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

Write-Host "It is strongly advised that you do not move .pst files that you intend to keep open in Outlook. Over time, these files can become corrupted. Are you sure you want to move your .pst files from H: to OneDrive?" -ForegroundColor Red -BackgroundColor Black -NoNewline
$PstConfirm = Write-Host " [y/n] " -ForegroundColor Yellow -NoNewline
$PstConfirm = Read-Host
  }

if ($PstConfirm -eq 'y' -and ($removedata -eq 'n')) {
    Write-Host "Your .pst files will be moved to OneDrive. Please ensure any associated Outlook folders have been closed before proceeding"
    Write-Host -ForegroundColor Green -BackgroundColor Black "`nCopying Data to OneDrive. This may take a few minutes...`n"
    robocopy $HDrive $OneDrive /V /log+:$logpath\log-$date.txt /E /Z /R:1 /W:1 /xf *.cfg *.ini *.one /xd "$HDrive\Profile" "$HDrive\WINDOWS" "$HDrive\CFGFiles" "$HDrive\DYMO" "$HDrive\DYMO Label" "$HDrive\TRIM" "$HDrive\TRIM Data" "$HDrive\My Received Files" "$HDrive\Remote Assistance Logs"  
    if ($lastexitcode -gt 0)  {
     write-host "Robocopy exit code:" $lastexitcode
     }
else {
    Write-Host -ForegroundColor White -BackgroundColor DarkBlue "Your H: drive contents have been copied to OneDrive. Verify the copy was successful, then review your H: Drive and manually remove any data already available in OneDrive at your earliest convenience. Please remember to empty your recycling bin following the cleanup" -NoNewline
  }}
elseif ($PstConfirm -eq 'n' -and ($removedata -eq 'n')) {
   Write-Host "Your .pst files will remain on the H: drive"
   Write-Host -ForegroundColor Green -BackgroundColor Black "`nCopying Data to OneDrive. This may take a few minutes...`n"
   robocopy $HDrive $OneDrive /V /log+:$logpath\log-$date.txt /E /Z /R:1 /W:1 /xf *.cfg *.ini *.one *.pst /xd "$HDrive\Profile" "$HDrive\WINDOWS" "$HDrive\CFGFiles" "$HDrive\DYMO" "$HDrive\DYMO Label" "$HDrive\TRIM" "$HDrive\TRIM Data" "$HDrive\My Received Files" "$HDrive\Remote Assistance Logs"  
   if ($lastexitcode -gt 0)  {
     write-host "Robocopy exit code:" $lastexitcode
     }
else {
   Write-Host -ForegroundColor White -BackgroundColor DarkBlue "Your H: drive contents have been copied to OneDrive. Verify the copy was successful, then review your H: Drive and manually remove any data already available in OneDrive at your earliest convenience. Please remember to empty your recycling bin following the cleanup" -NoNewline
  }}
elseif ($PstConfirm -eq 'y' -and ($removedata -eq 'y')) {
    Write-Host "Your .pst files will be moved to OneDrive. Please ensure any associated Outlook folders have been closed before proceeding"
    Write-Host -ForegroundColor Green -BackgroundColor Black "`nCopying Data to OneDrive. This may take a few minutes...`n"
    robocopy /MOVE /E /Z $HDrive $OneDrive /V /log+:$logpath\log-$date.txt /R:1 /W:1 /xf *.cfg *.ini *.one /xd "$HDrive\Profile" "$HDrive\WINDOWS" "$HDrive\CFGFiles" "$HDrive\DYMO" "$HDrive\DYMO Label" "$HDrive\TRIM" "$HDrive\TRIM Data" "$HDrive\My Received Files" "$HDrive\Remote Assistance Logs"  
   if ($lastexitcode -gt 0)  {
     write-host "Robocopy exit code:" $lastexitcode
     }
else {
    Write-Host -ForegroundColor White -BackgroundColor DarkBlue "Your H: drive contents have been moved to OneDrive."
  }}
elseif ($PstConfirm -eq 'n' -and ($removedata -eq 'y')) {
   Write-Host "Your .pst files will remain on the H: drive"
   Write-Host -ForegroundColor Green -BackgroundColor Black "`nCopying Data to OneDrive. This may take a few minutes...`n"
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