set-executionpolicy unrestricted


Function Tweaks-Muchi-Power-Plan {

	# Define download URL and destination path
	$downloadUrl = "https://www.dropbox.com/scl/fi/r995j2ty9danfh27fr0ni/Muchi.pow?rlkey=nwm137ybjagomyy37mz76j7s6&st=pg7b92cv&dl=1"
	$destinationPath = "C:\_temp\Muchi.pow"
	Clear-Host
	
	# Pause for 1 second
	Start-Sleep -Seconds 1

	# Create the target directory if it doesn't exist
	$targetDir = Split-Path -Path $destinationPath
if (!(Test-Path -Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force
}

	Clear-Host
	
	# Pause for 1 second
	Start-Sleep -Seconds 1

	# Download the file
	Invoke-WebRequest -Uri $downloadUrl -OutFile $destinationPath
	Clear-Host
	
	# Pause for 1 second
	Start-Sleep -Seconds 1

	# Import the power plan
	powercfg -import $destinationPath
	Clear-Host

	# Get all power schemes
	$schemes = powercfg /l

	# Find the GUID of the power scheme containing "Muchi"
	$schemeGuid = $schemes | Select-String -Pattern "Muchi" | ForEach-Object { $_.ToString().Split()[3] }

	# Set the active power scheme
if ($schemeGuid) {
    powercfg /s $schemeGuid
} else {
    Write-Host "Failed To Import Power Scheme 'Muchi'"
	Write-Host ""
	Write-Host "https://www.dropbox.com/scl/fi/r995j2ty9danfh27fr0ni/Muchi.pow?rlkey=nwm137ybjagomyy37mz76j7s6&st=pg7b92cv&dl=1"
	Write-Host ""
	Write-Host "Download & Import Manually Using Link Above, If You Wish."
	Write-Host ""
	Write-Host "Resuming In 5"
	Start-Sleep -Seconds 5
}
}

Function Tweaks-Take-Owner {
	clear-host
	Write-Host "Adding Take Ownership To Context Menu!"
	Start-Sleep -Seconds 2



# Define the path for the .reg file
$regFilePath = "C:\_temp\takeownership.reg"

# Create the registry content for the .reg file
$regContent = @"
Windows Registry Editor Version 5.00

    ; Adds "Take Ownership" to the Right Click Context Menu
                
    [-HKEY_CLASSES_ROOT\*\shell\TakeOwnership]
    [-HKEY_CLASSES_ROOT\*\shell\runas]
              
    [HKEY_CLASSES_ROOT\*\shell\TakeOwnership]
    @="Take Ownership"
    "Extended"=-
    "HasLUAShield"=""
    "NoWorkingDirectory"=""
    "NeverDefault"=""
              
    [HKEY_CLASSES_ROOT\*\shell\TakeOwnership\command]
    @="powershell -windowstyle hidden -command \"Start-Process cmd -ArgumentList '/c takeown /f \\\"%1\\\" && icacls \\\"%1\\\" /grant *S-1-3-4:F /t /c /l & pause' -Verb runAs\""
    "IsolatedCommand"= "powershell -windowstyle hidden -command \"Start-Process cmd -ArgumentList '/c takeown /f \\\"%1\\\" && icacls \\\"%1\\\" /grant *S-1-3-4:F /t /c /l & pause' -Verb runAs\""

    [HKEY_CLASSES_ROOT\Directory\shell\TakeOwnership]
    @="Take Ownership"
    "AppliesTo"="NOT (System.ItemPathDisplay:=\"C:\\Users\" OR System.ItemPathDisplay:=\"C:\\ProgramData\" OR System.ItemPathDisplay:=\"C:\\Windows\" OR System.ItemPathDisplay:=\"C:\\Windows\\System32\" OR System.ItemPathDisplay:=\"C:\\Program Files\" OR System.ItemPathDisplay:=\"C:\\Program Files (x86)\")"
    "Extended"=-
    "HasLUAShield"=""
    "NoWorkingDirectory"=""
    "Position"="middle"
              
    [HKEY_CLASSES_ROOT\Directory\shell\TakeOwnership\command]
    @="powershell -windowstyle hidden -command \"$Y = ($null | choice).Substring(1,1); Start-Process cmd -ArgumentList ('/c takeown /f \\\"%1\\\" /r /d ' + $Y + ' && icacls \\\"%1\\\" /grant *S-1-3-4:F /t /c /l /q & pause') -Verb runAs\""
    "IsolatedCommand"="powershell -windowstyle hidden -command \"$Y = ($null | choice).Substring(1,1); Start-Process cmd -ArgumentList ('/c takeown /f \\\"%1\\\" /r /d ' + $Y + ' && icacls \\\"%1\\\" /grant *S-1-3-4:F /t /c /l /q & pause') -Verb runAs\""
                
    [HKEY_CLASSES_ROOT\Drive\shell\runas]
    @="Take Ownership"
    "Extended"=-
    "HasLUAShield"=""
    "NoWorkingDirectory"=""
    "Position"="middle"
    "AppliesTo"="NOT (System.ItemPathDisplay:=\"C:\\\")"
              
    [HKEY_CLASSES_ROOT\Drive\shell\runas\command]
    @="cmd.exe /c takeown /f \"%1\\\" /r /d y && icacls \"%1\\\" /grant *S-1-3-4:F /t /c & Pause"
    "IsolatedCommand"="cmd.exe /c takeown /f \"%1\\\" /r /d y && icacls \"%1\\\" /grant *S-1-3-4:F /t /c & Pause"
"@


# Create the _temp folder if it doesn't exist
if (-not (Test-Path "C:\_temp")) {
    New-Item -Path "C:\" -Name "_temp" -ItemType Directory
}

# Write the content to the .reg file
$regContent | Out-File -FilePath $regFilePath -Force

# Open the .reg file silently (without showing any window) using regedit
Start-Process "regedit.exe" -ArgumentList "/s $regFilePath" -WindowStyle Hidden

# Wait for 2 seconds before removing the .reg file
Start-Sleep -Seconds 2

# Delete the .reg file after use
Remove-Item -Path $regFilePath -Force
}

Function Tweaks-Disable-UAC {
	clear-host
	Write-Host "Disabling UAC!"
	Start-Sleep -Seconds 2


# Disable UAC
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableLUA" -PropertyType DWord -Value 0 -Force
}

Function Tweaks-Disable-Wifi-Sense {
	clear-host
	Write-Host "Disabling Wi-Fi Sense!"
	Start-Sleep -Seconds 2
	
	
# Disable Wifi-Sense
New-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -PropertyType DWord -Value 0 -Force
New-ItemProperty -Path "HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -PropertyType DWord -Value 0 -Force
}

Function Tweaks-Disable-Win-Ads {
	clear-host
	Write-Host "Disabling Advertising!"
	Start-Sleep -Seconds 2

# DISABLE ADVERTISING & PROMOTIONAL
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "FeatureManagementEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenOverlayEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SlideshowEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-314563Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContentEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0
}

Function Tweaks-DVR-Settings {
	clear-host
	Write-Host "Setting GameDVR Settings!"
	Start-Sleep -Seconds 2


# disable game bar
Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0

# disable enable open xbox game bar using game controller
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Value 0

# Disable Xbox GameDVR
New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -PropertyType DWord -Value 0 -Force

# other DVR settings
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AudioEncodingBitrate" -Value 1305600
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AudioCaptureEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "CustomVideoEncodingBitrate" -Value 40614400
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "CustomVideoEncodingHeight" -Value 720
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "CustomVideoEncodingWidth" -Value 1280
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "HistoricalBufferLength" -Value 30
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "HistoricalBufferLengthUnit" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "HistoricalCaptureEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "HistoricalCaptureOnBatteryAllowed" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "HistoricalCaptureOnWirelessDisplayAllowed" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "MaximumRecordLength" -Value ([byte[]]@(0x00, 0xD0, 0x88, 0xC3, 0x10, 0x00, 0x00, 0x00))
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VideoEncodingBitrateMode" -Value 2
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VideoEncodingResolutionMode" -Value 2
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VideoEncodingFrameRateMode" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "EchoCancellationEnabled" -Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "CursorCaptureEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKToggleGameBar" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKMToggleGameBar" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKSaveHistoricalVideo" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKMSaveHistoricalVideo" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKToggleRecording" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKMToggleRecording" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKTakeScreenshot" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKMTakeScreenshot" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKToggleRecordingIndicator" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKMToggleRecordingIndicator" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKToggleMicrophoneCapture" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKMToggleMicrophoneCapture" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKToggleCameraCapture" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKMToggleCameraCapture" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKToggleBroadcast" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "VKMToggleBroadcast" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "MicrophoneCaptureEnabled" -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "SystemAudioGain" -Value ([byte[]]@(0x10, 0x27, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "MicrophoneGain" -Value ([byte[]]@(0x10, 0x27, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00))
}

Function Tweaks-Game-Mode {
	clear-host
	Write-Host "Enabling Game Mode!"
	Start-Sleep -Seconds 2


	# enable game mode
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1
}

Function Tweaks-Misc-Tweaks {
	clear-host
	Write-Host "Setting Misc Tweaks!"
	Start-Sleep -Seconds 2

	# Unhide "Hub Selective Suspend Timeout"
	Set-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\0853a681-27c8-4100-a2fd-82013e970683" -Name "Attributes" -Value 2

	# Unhide "USB 3 Link Power Management"
	Set-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\Power\PowerSettings\2a737441-1930-4402-8d77-b2bebba308a3\d4e98f31-5ffe-4ce1-be31-1b38b384c009" -Name "Attributes" -Value 2

	# Disable Tablet Mode and set desktop mode on sign-in
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "TabletMode" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" -Name "SignInMode" -PropertyType DWord -Value 1 -Force

	# Enable Long File Paths with Up to 32,767 Characters
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "LongPathsEnabled" -PropertyType DWord -Value 1 -Force

	# Set high contrast flags
	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\HighContrast" -Name "Flags" -PropertyType String -Value "4194" -Force

	# Set sound sentry settings
	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\SoundSentry" -Name "Flags" -PropertyType String -Value "0" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\SoundSentry" -Name "FSTextEffect" -PropertyType String -Value "0" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\SoundSentry" -Name "TextEffect" -PropertyType String -Value "0" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\SoundSentry" -Name "WindowsEffect" -PropertyType String -Value "0" -Force

	# Enable display full path in the title bar
	New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CabinetState" -Name "FullPath" -PropertyType DWord -Value 1 -Force

	# Set sound communications to do nothing
	New-ItemProperty -Path "HKCU:\Software\Microsoft\Multimedia\Audio" -Name "UserDuckingPreference" -PropertyType DWord -Value 3 -Force

	# Optimize video quality on battery
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\VideoSettings" -Name "VideoQualityOnBattery" -Value 1
}

Function Tweaks-Performance-Tweaks {
	clear-host
	Write-Host "Performance Tweaks!"
	Start-Sleep -Seconds 2


	# Enable old NVIDIA sharpening
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\nvlddmkm\FTS" -Name "EnableGR535" -PropertyType DWord -Value 0 -Force

	# Disable variable refresh rate and enable optimizations for windowed games
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences" -Name "DirectXUserGlobalSettings" -Value "SwapEffectUpgradeEnable=1;VRROptimizeEnable=0;"

	# set appearance options to custom
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 3

	# disable animate controls and elements inside windows
	# disable fade or slide menus into view
	# disable fade or slide tooltips into view
	# disable fade out menu items after clicking
	# disable show shadows under mouse pointer
	# disable show shadows under windows
	# disable slide open combo boxes
	# disable smooth-scroll list boxes
	# enable smooth edges of screen fonts
	# 100% dpi scaling
	# disable fix scaling for apps
	# disable menu show delay
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value 0x9012038000000000
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "FontSmoothing" -Value "2"
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "LogPixels" -Value 96
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "Win8DpiScaling" -Value 1
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "EnablePerProcessSystemDPI" -Value 0
	Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value "0"

	# Turn on hardware accelerated GPU scheduling
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -PropertyType DWord -Value 2 -Force

	# Adjust for best performance of programs
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -PropertyType DWord -Value 38 -Force

	# Give Multimedia Applications like Games and Video Editing a Higher Priority
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -PropertyType DWord -Value 10 -Force

	# Give Graphics Cards a Higher Priority for Gaming
	# Give the CPU a Higher Priority for Gaming
	# Give Games a higher priority in the system's scheduling
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -PropertyType DWord -Value 8 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -PropertyType DWord -Value 6 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Scheduling Category" -PropertyType String -Value "High" -Force

	# Unpark CPU cores by setting the maximum processor state
	Set-ItemProperty -Path "HKLM:\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\0cc5b647-c1df-4637-891a-dec35c318583" -Name "ValueMax" -Value 0

	# Disable power throttling
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1
}

Function Tweaks-Annoyances {
	clear-host
	Write-Host "Disabling, Preventing & Removing Annoyances!"
	Start-Sleep -Seconds 2

	# Disable Cortana
	New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -PropertyType DWord -Value 0 -Force

	# Disable Windows Copilot system-wide
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -PropertyType DWord -Value 1 -Force

	# Disable OneDrive Automatic Backups
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\OneDrive" -Name "KFMBlockOptIn" -PropertyType DWord -Value 1 -Force

	# Disable "Push To Install" feature
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\PushToInstall" -Name "DisablePushToInstall" -PropertyType DWord -Value 1 -Force

	# Disable Windows Consumer Features and related content
	New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableConsumerAccountStateContent" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableCloudOptimizedContent" -PropertyType DWord -Value 1 -Force

	# Disable BitLocker Auto Encryption
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\BitLocker" -Name "PreventDeviceEncryption" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EnhancedStorageDevices" -Name "TCGSecurityActivationDisabled" -PropertyType DWord -Value 1 -Force

	# Disable Activity History
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -PropertyType DWord -Value 0 -Force

	# Disable Location Tracking
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" -Name "Status" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SYSTEM\Maps" -Name "AutoUpdateEnabled" -PropertyType DWord -Value 0 -Force

	# Disable Telemetry
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -PropertyType DWord -Value 0 -Force

	# Disable Telemetry and Feedback Notifications
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -PropertyType DWord -Value 1 -Force

	# Disable Windows Ink Workspace
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" -Name "AllowWindowsInkWorkspace" -PropertyType DWord -Value 0 -Force

	# Disable Advertising ID for All Users
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -PropertyType DWord -Value 1 -Force

	# Disable Device Installation Settings
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -PropertyType DWord -Value 1 -Force

	# Disable storage sense
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\StorageSense" -Name "AllowStorageSenseGlobal" -PropertyType DWord -Value 0 -Force

	# Disable background apps
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" -Name "LetAppsRunInBackground" -PropertyType DWord -Value 2 -Force

	# Disable widgets
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\NewsAndInterests\AllowNewsAndInterests" -Name "value" -PropertyType DWord -Value 0 -Force

	# disable show me notification in the settings app
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SystemSettings\AccountNotifications" -Name "EnableAccountNotifications" -Value 0

	# disable voice activation
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" -Name "AgentActivationEnabled" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Speech_OneCore\Settings\VoiceActivation\UserPreferenceForAllApps" -Name "AgentActivationLastUsed" -Value 0

	# disable other devices 
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\bluetoothSync" -Name "Value" -Value "Deny"

	# disable let websites show me locally relevant content by accessing my language list
	Set-ItemProperty -Path "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Value 1

	# disable let windows improve start and search results by tracking app launches  
	Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\EdgeUI" -Name "DisableMFUTracking" -Value 1

	# disable personal inking and typing dictionary
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Value 1
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Value 1
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Value 0

	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Value 0

	# feedback frequency never
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "PeriodInNanoSeconds" -Value "-"

	# Hide the Meet Now Button on the Taskbar
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -PropertyType DWord -Value 1 -Force

	# Remove Windows widgets from taskbar
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Dsh" -Name "AllowNewsAndInterests" -PropertyType DWord -Value 0 -Force

	# Remove news and interests from Taskbar
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" -Name "EnableFeeds" -PropertyType DWord -Value 0 -Force

	# Disable notify me when the clock changes
	New-ItemProperty -Path "HKCU:\Control Panel\TimeDate" -Name "DstNotification" -PropertyType DWord -Value 0 -Force

	# Disable web search in start menu
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1

	# Remove Meet Now
	Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuMFUprogramsList" -ErrorAction SilentlyContinue
	Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoInstrumentation" -ErrorAction SilentlyContinue
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "HideSCAMeetNow" -Value 1

	# Remove search from taskbar
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0

	# Disable Windows managing default printer
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Windows" -Name "LegacyDefaultPrinterMode" -Value 1

	# Disable writing with fingertip
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\TabletTip\EmbeddedInkControl" -Name "EnableInkingWithTouch" -Value 0

	# Disable notifications
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "LockScreenToastEnabled" -Value 0

	# Disable Allow Notifications to Play Sounds, Disable Notifications on Lock Screen
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings" -Name "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK" -Value 0

	# Disable specific system toast notifications
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" -Name "Enabled" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel" -Name "Enabled" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.CapabilityAccess" -Name "Enabled" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.StartupApp" -Name "Enabled" -Value 0

	# Disable Profile Engagement (e.g., Scoobe system setting)
	Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Value 0

	# Disable suggested actions
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SmartActionPlatform\SmartClipboard" -Name "Disabled" -Value 1

	# Disable Windows input experience preload
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\input" -Name "IsInputAppPreloadEnabled" -Value 0

	# Disable prelaunch of Windows apps
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Dsh" -Name "IsPrelaunchEnabled" -Value 0

	# Disable Windows Copilot
	Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\WindowsCopilot" -Name "TurnOffWindowsCopilot" -Value 1

	# Remove gallery
	Remove-ItemProperty -Path "HKCU:\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" -Name "System.IsPinnedToNameSpaceTree"

	# Remove OneDrive Setup
	Remove-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "OneDriveSetup"

	# Hide the Try New Outlook Button
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Office\16.0\Outlook\Options\General" -Name "HideNewOutlookToggle" -Value 0

	# Disable hibernate
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Value 0

	# Disable default hibernate settings
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabledDefault" -Value 0

	# Disable Fast Startup (Hiberboot)
	Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" -Name "HiberbootEnabled" -Value 0

	# Prevent Dev Home Installation
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate" -Force -ErrorAction SilentlyContinue

	# Prevent New Outlook for Windows Installation
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate" -Force -ErrorAction SilentlyContinue

	# Prevent Chat Auto Installation
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" -Name "ConfigureChatAutoInstall" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" -Name "ChatIcon" -PropertyType DWord -Value 3 -Force

	# Disable Account Info
	Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\userAccountInformation" -Name "Value" -Value "Deny" -Force

	# Disable Startup Sound
	New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\BootAnimation" -Name "DisableStartupSound" -PropertyType DWord -Value 1 -Force

	# Disable Startup Sound in Edition Overrides
	New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\EditionOverrides" -Name "UserSetting_DisableStartupSound" -PropertyType DWord -Value 1 -Force

	# Disable launch of accessibility tools
	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\SlateLaunch" -Name "ATapp" -PropertyType String -Value "" -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\SlateLaunch" -Name "LaunchAT" -PropertyType DWord -Value 0 -Force

	# Disable ease of access settings
	New-ItemProperty -Path "HKCU:\Software\Microsoft\Ease of Access" -Name "selfvoice" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKCU:\Software\Microsoft\Ease of Access" -Name "selfscan" -PropertyType DWord -Value 0 -Force

	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility" -Name "Sound on Activation" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKCU:\Control Panel\Accessibility" -Name "Warning Sounds" -PropertyType DWord -Value 0 -Force

	# Remove 3D objects
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Force
	Remove-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Force

	# Remove Home Folder
	Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" -Force

	# Disable archive apps
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Appx" -Name "AllowAutomaticAppArchiving" -PropertyType DWord -Value 0 -Force

	# Disable remote assistance
	New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -PropertyType DWord -Value 0 -Force

	# Disable automatic maintenance
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\Maintenance" -Name "MaintenanceDisabled" -PropertyType DWord -Value 1 -Force

	# Disable report problems
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -PropertyType DWord -Value 1 -Force

	# Disable use my sign-in info after restart
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "DisableAutomaticRestartSignOn" -PropertyType DWord -Value 1 -Force

	# Disable allowing other network users to control or disable the shared internet connection
	New-ItemProperty -Path "HKLM:\System\ControlSet001\Control\Network\SharedAccessConnection" -Name "EnableControl" -PropertyType DWord -Value 0 -Force

	# Remove All Pinned Apps from the Start Menu
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start" -Name "ConfigureStartPins" -PropertyType String -Value '{ "pinnedList": [] }' -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start" -Name "ConfigureStartPins_ProviderSet" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start" -Name "ConfigureStartPins_WinningProvider" -PropertyType String -Value "B5292708-1619-419B-9923-E5D9F3925E71" -Force

	# Remove All Pinned Apps from the Start Menu (additional provider)
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start" -Name "ConfigureStartPins" -PropertyType String -Value '{ "pinnedList": [] }' -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start" -Name "ConfigureStartPins_LastWrite" -PropertyType DWord -Value 1 -Force

	# Block "Allow my organization to manage my device" pop-ups
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" -Name "BlockAADWorkplaceJoin" -PropertyType DWord -Value 1 -Force

	# disable search highlights
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDynamicSearchBoxEnabled" -Value 0

	# disable search history
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsDeviceSearchHistoryEnabled" -Value 0

	# disable safe search
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "SafeSearchMode" -Value 0

	# disable cloud content search for work or school account
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsAADCloudSearchEnabled" -Value 0

	# disable cloud content search for microsoft account
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\SearchSettings" -Name "IsMSACloudSearchEnabled" -Value 0

	# disable show the voice typing mic button
	# disable typing insights
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\input\Settings" -Name "IsVoiceTypingKeyEnabled" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\input\Settings" -Name "InsightsEnabled" -Value 0

	# disable capitalize the first letter of each sentence
	# disable play key sounds as I type
	# disable add a period after I double-tap the spacebar
	# disable show key background
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\TabletTip\1.7" -Name "EnableAutoShiftEngage" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\TabletTip\1.7" -Name "EnableKeyAudioFeedback" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\TabletTip\1.7" -Name "EnableDoubleTapSpace" -Value 0
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\TabletTip\1.7" -Name "IsKeyBackgroundEnabled" -Value 0

	# Disable match my windows accent color
	Set-ItemProperty -Path "HKCU:\Software\Microsoft\Lighting" -Name "UseSystemAccentColor" -Value 0

	# Disable Automatic Driver Installation
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Update" -Name "ExcludeWUDriversInQualityUpdate" -PropertyType DWord -Value 1 -Force -BackgroundColor Black -NoNewline
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Update" -Name "ExcludeWUDriversInQualityUpdate" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" -Name "ExcludeWUDriversInQualityUpdate" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "ExcludeWUDriversInQualityUpdate" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Update\ExcludeWUDriversInQualityUpdate" -Name "value" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" -Name "PreventDeviceMetadataFromNetwork" -PropertyType DWord -Value 1 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "SearchOrderConfig" -PropertyType DWord -Value 0 -Force
	New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" -Name "DontSearchWindowsUpdate" -PropertyType DWord -Value 1 -Force
}

Function Tweaks-Sch-Tasks {
	Clear-Host
  	Write-Host "Scheduled Tasks!"
	Start-Sleep -Seconds 2
  # Disables Telemetry
  # Disable Scheduled Tasks
  $scheduledTasks = @(
      "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
      "Microsoft\Windows\Application Experience\ProgramDataUpdater",
      "Microsoft\Windows\Autochk\Proxy",
      "Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
      "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
      "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
      "Microsoft\Windows\Feedback\Siuf\DmClient",
      "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
      "Microsoft\Windows\Windows Error Reporting\QueueReporting",
      "Microsoft\Windows\Application Experience\MareBackup",
      "Microsoft\Windows\Application Experience\StartupAppTask",
      "Microsoft\Windows\Application Experience\PcaPatchDbTask",
      "Microsoft\Windows\Maps\MapsUpdateTask"
  )
  foreach ($task in $scheduledTasks) {
      schtasks /Change /TN $task /Disable
  }
}

Function Tweaks-Delete-OneDrive {
	Clear-Host
  	Write-Host "Deleting OneDrive!"
	Start-Sleep -Seconds 2
  
  # Check if OneDrive exists for each user
Get-ChildItem "$env:SystemDrive\Users" | ForEach-Object {
    if (Test-Path "$($_.FullName)\OneDrive") {
        if ((Get-ChildItem "$($_.FullName)\OneDrive" -File).Count -gt 0) {
            Write-Host "Not stripping OneDrive as OneDrive files exist, exiting..."
            exit 6000
        }
    }
}

# Terminate OneDrive process
Stop-Process -Name "OneDrive" -Force -ErrorAction SilentlyContinue

# Uninstall OneDrive Setup if it exists
$oneDrivePaths = @(
    "$env:windir\System32\OneDriveSetup.exe",
    "$env:windir\SysWOW64\OneDriveSetup.exe"
)

foreach ($path in $oneDrivePaths) {
    if (Test-Path $path) {
        & $path /uninstall | Out-Null
    }
}

# Remove OneDrive related files and registry entries for users with "Volatile Environment"
Get-ChildItem "HKU:\" | Where-Object { $_.Name -match 'S-.*' -or $_.Name -match 'AME_UserHive_[^_]*' } | ForEach-Object {
    $userKey = $_.Name
    $volEnvKey = "HKU\$userKey\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\BannerStore"
    if (Test-Path $volEnvKey) {
        Write-Host "Making changes for $userKey..."
        Remove-ItemProperty -Path "HKU\$userKey\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\BannerStore" -Name "OneDrive" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKU\$userKey\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers\Handlers" -Name "OneDrive" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKU\$userKey\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" -Name "OneDrive" -Force -ErrorAction SilentlyContinue
        Remove-ItemProperty -Path "HKU\$userKey\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" -Name "OneDrive" -Force -ErrorAction SilentlyContinue
    }
}

# Remove OneDrive related directories
Remove-Item -Path "$env:ProgramData\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue

# Remove user-specific OneDrive directories
Get-ChildItem "$env:SystemDrive\Users" | ForEach-Object {
    Remove-Item -Path "$($_.FullName)\AppData\Local\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$($_.FullName)\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path "$($_.FullName)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -Force -ErrorAction SilentlyContinue
}

# Delete OneDrive registry entries
Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SyncRootManager" | Where-Object { $_.Name -like "*OneDrive*" } | ForEach-Object {
    Remove-Item -Path $_.PSPath -Force -ErrorAction SilentlyContinue
}

# Delete scheduled tasks for OneDrive
Get-ScheduledTask | Where-Object { $_.TaskName -match "OneDrive Reporting Task|OneDrive Standalone Update Task" } | ForEach-Object {
    Unregister-ScheduledTask -TaskName $_.TaskName -Force -ErrorAction SilentlyContinue
}


}

Function Tweaks-KBM {
	Clear-Host	
	Write-Host "KBM Tweaks!"
	Start-Sleep -Seconds 2
	
# Disable DPI scaling
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "UseDpiScaling" -Value 0
	
# Set keyboard response flags and settings
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "Flags" -PropertyType String -Value "2" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "AutoRepeatRate" -PropertyType String -Value "0" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "AutoRepeatDelay" -PropertyType String -Value "0" -Force

# Set mouse keys settings
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\MouseKeys" -Name "Flags" -PropertyType String -Value "130" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\MouseKeys" -Name "MaximumSpeed" -PropertyType String -Value "39" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\MouseKeys" -Name "TimeToMaximumSpeed" -PropertyType String -Value "3000" -Force

# Set sticky keys flags
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -PropertyType String -Value "2" -Force

# Set toggle keys flags
New-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" -Name "Flags" -PropertyType String -Value "34" -Force
	
# Adjust mouse settings
New-ItemProperty -Path "HKU\.DEFAULT\Control Panel\Mouse" -Name "MouseSpeed" -PropertyType String -Value "0" -Force
New-ItemProperty -Path "HKU\.DEFAULT\Control Panel\Mouse" -Name "MouseThreshold1" -PropertyType String -Value "0" -Force
New-ItemProperty -Path "HKU\.DEFAULT\Control Panel\Mouse" -Name "MouseThreshold2" -PropertyType String -Value "0" -Force

# Disable enhance pointer precision (mouse fix, no accel with EPP on)
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -PropertyType String -Value "0" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -PropertyType String -Value "0" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -PropertyType String -Value "0" -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSensitivity" -PropertyType String -Value "10" -Force

# Set custom mouse curve settings (SmoothMouseXCurve and SmoothMouseYCurve)
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "SmoothMouseXCurve" -PropertyType Binary -Value ([byte[]]@(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xC0, 0xCC, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80, 0x99, 0x19, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x66, 0x26, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x33, 0x33, 0x00, 0x00, 0x00, 0x00, 0x00)) -Force
New-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "SmoothMouseYCurve" -PropertyType Binary -Value ([byte[]]@(0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xA8, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0x00, 0x00, 0x00, 0x00, 0x00)) -Force

# Add "KeyboardDataQueueSize" to the kbdclass registry
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\kbdclass\Parameters" -Name "KeyboardDataQueueSize" -Value 30 -Type DWord

# Add "MouseDataQueueSize" to the mouclass registry
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\mouclass\Parameters" -Name "MouseDataQueueSize" -Value 30 -Type DWord
}

Function Tweaks-Services {
	Clear-Host
  	Write-Host "Optimizing Services!"
	Start-Sleep -Seconds 2
  
    # Set Services to Manual
  Set-Service -Name 'AJRouter' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'ALG' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'AppIDSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'AppMgmt' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'AppReadiness' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'AppVClient' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'AppXSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Appinfo' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'AssignedAccessManagerSvc' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'AudioEndpointBuilder' -StartupType Automatic -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'AudioSrv' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'Audiosrv' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'AxInstSV' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'BDESVC' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'BFE' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'BTAGService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'BcastDVRUserService_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'BrokerInfrastructure' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'Browser' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'BthAvctpSvc' -StartupType Automatic -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'BthHFSrv' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'CDPSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'CDPUserSvc_*' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'COMSysApp' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'CaptureService_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'CertPropSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'ClipSVC' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'ConsentUxUserSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'CoreMessagingRegistrar' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'CredentialEnrollmentManagerUserSvc_*' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'CryptSvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'CscService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DPS' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'DcomLaunch' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'DcpSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DevQueryBroker' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DeviceAssociationBrokerSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DeviceAssociationService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DeviceInstall' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DevicePickerUserSvc_*' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'DevicesFlowUserSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Dhcp' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'DiagTrack' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'DialogBlockingService' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'DispBrokerDesktopSvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'DisplayEnhancementService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DmEnrollmentSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Dnscache' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'DoSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DsSvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'DsmSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'DusmSvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'EFS' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'EapHost' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'EntAppSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'EventLog' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'EventSystem' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'FDResPub' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Fax' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'FontCache' -StartupType Automatic -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'FrameServer' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'FrameServerMonitor' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'GraphicsPerfSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'HomeGroupListener' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'HomeGroupProvider' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'HvHost' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'IEEtwCollectorService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'IKEEXT' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'InstallService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'InventorySvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'IpxlatCfgSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'KeyIso' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'KtmRm' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'LSM' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'LanmanServer' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'LanmanWorkstation' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'LicenseManager' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'LxpSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'MSDTC' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'MSiSCSI' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'MapsBroker' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'McpManagementService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'MessagingService_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'MicrosoftEdgeElevationService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'MixedRealityOpenXRSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'MpsSvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'MsKeyboardFilter' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NPSMSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NaturalAuthentication' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NcaSvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'NcbService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NcdAutoSetup' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NetSetupSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NetTcpPortSharing' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'Netlogon' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'Netman' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NgcCtnrSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NgcSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'NlaSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'OneSyncSvc_*' -StartupType Automatic -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'P9RdrService_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PNRPAutoReg' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PNRPsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PcaSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PeerDistSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PenService_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PerfHost' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PhoneSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PimIndexMaintenanceSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PlugPlay' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'PolicyAgent' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Power' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'PrintNotify' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'PrintWorkflowUserSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'ProfSvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'PushToInstall' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'QWAVE' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'RasAuto' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'RasMan' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'RemoteAccess' -StartupType Disabled -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'RemoteRegistry' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'RetailDemo' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'RmSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'RpcEptMapper' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'RpcLocator' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'RpcSs' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'SCPolicySvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SCardSvr' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SDRSVC' -StartupType Manual -ErrorAction Continue 
  Set-Service -Name 'SEMgrSvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'SENS' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'SNMPTRAP' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SNMPTrap' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SSDPSRV' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SamSs' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'ScDeviceEnum' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Schedule' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'SecurityHealthService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Sense' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SensorDataService' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'SensorService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SensrSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SessionEnv' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SgrmBroker' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'SharedAccess' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SharedRealitySvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'ShellHWDetection' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'SmsRouter' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Spooler' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'SstpSvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'StateRepository' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'StiSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'StorSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'SysMain' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'SystemEventsBroker' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'TabletInputService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'TapiSrv' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'TermService' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'TextInputManagementService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Themes' -StartupType Automatic -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'TieringEngineService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'TimeBroker' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'TimeBrokerSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'TokenBroker' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'TrkWks' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'TroubleshootingSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'TrustedInstaller' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'UI0Detect' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'UdkUserSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'UevAgentService' -StartupType Disabled -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'UmRdpService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'UnistoreSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'UserDataSvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'UserManager' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'UsoSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'VGAuthService' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'VMTools' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'VSS' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'VacSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'VaultSvc' -StartupType Automatic -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'W32Time' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WEPHOSTSVC' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WFDSConMgrSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WMPNetworkSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WManSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WPDBusEnum' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WSService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WSearch' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WaaSMedicSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WalletService' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'WarpJITSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WbioSrvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Wcmsvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'WcsPlugInService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WdNisSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WdiServiceHost' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WdiSystemHost' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WebClient' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Wecsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WerSvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'WiaRpc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WinDefend' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'WinHttpAutoProxySvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WinRM' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'Winmgmt' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'WlanSvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'WpcMonSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WpnService' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'WpnUserService_*' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'WwanSvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'XblAuthManager' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'XblGameSave' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'XboxGipSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'XboxNetApiSvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'autotimesvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'bthserv' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'camsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'cbdhsvc_*' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'cloudidsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'dcsvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'defragsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'diagnosticshub.standardcollector.service' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'diagsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'dmwappushservice' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'dot3svc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'edgeupdate' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'edgeupdatem' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'embeddedmode' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'fdPHost' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'fhsvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'gpsvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'hidserv' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'icssvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'iphlpsvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'lfsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'lltdsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'lmhosts' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'mpssvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'msiserver' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'netprofm' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'nsi' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'p2pimsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'p2psvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'perceptionsimulation' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'pla' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'seclogon' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'shpamsvc' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'smphost' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'spectrum' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'sppsvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'ssh-agent' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'svsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'swprv' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'tiledatamodelsvc' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'tzautoupdate' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'uhssvc' -StartupType Disabled -ErrorAction Continue
  Set-Service -Name 'upnphost' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vds' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vm3dservice' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vmicguestinterface' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'vmicheartbeat' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vmickvpexchange' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vmicrdv' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vmicshutdown' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vmictimesync' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vmicvmsession' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vmicvss' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'vmvss' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'wbengine' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'wcncsvc' -StartupType Manual -ErrorAction Continue
  Clear-Host
  Set-Service -Name 'webthreatdefsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'webthreatdefusersvc_*' -StartupType Automatic -ErrorAction Continue
  Set-Service -Name 'wercplsupport' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'wisvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'wlidsvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'wlpasvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'wmiApSrv' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'workfolderssvc' -StartupType Manual -ErrorAction Continue
  Set-Service -Name 'wudfsvc' -StartupType Manual -ErrorAction Continue
}

Function Tweaks-Debloat1 {
	Clear-Host
	Write-Host "Debloating!"
	Start-Sleep -Seconds 2


Get-AppxProvisionedPackage -Online |
  Where-Object -Property 'DisplayName' -In -Value @(
  'Microsoft.Microsoft3DViewer';
  'Microsoft.BingSearch';
  'Microsoft.WindowsCamera';
  'Clipchamp.Clipchamp';
  'Microsoft.WindowsAlarms';
  'Microsoft.549981C3F5F10';
  'Microsoft.Windows.DevHome';
  'MicrosoftCorporationII.MicrosoftFamily';
  'Microsoft.WindowsFeedbackHub';
  'Microsoft.GetHelp';
  'microsoft.windowscommunicationsapps';
  'Microsoft.WindowsMaps';
  'Microsoft.ZuneVideo';
  'Microsoft.BingNews';
  'Microsoft.MicrosoftOfficeHub';
  'Microsoft.Office.OneNote';
  'Microsoft.OutlookForWindows';
  'Microsoft.Paint';
  'Microsoft.MSPaint';
  'Microsoft.People';
  'Microsoft.Windows.Photos';
  'Microsoft.PowerAutomateDesktop';
  'MicrosoftCorporationII.QuickAssist';
  'Microsoft.SkypeApp';
  'Microsoft.ScreenSketch';
  'Microsoft.MicrosoftSolitaireCollection';
  'Microsoft.MicrosoftStickyNotes';
  'MSTeams';
  'Microsoft.Getstarted';
  'Microsoft.Todos';
  'Microsoft.WindowsSoundRecorder';
  'Microsoft.BingWeather';
  'Microsoft.ZuneMusic';
  'Microsoft.WindowsTerminal';
  'Microsoft.Xbox.TCUI';
  'Microsoft.XboxApp';
  'Microsoft.XboxGameOverlay';
  'Microsoft.XboxGamingOverlay';
  'Microsoft.XboxIdentityProvider';
  'Microsoft.XboxSpeechToTextOverlay';
  'Microsoft.GamingApp';
  'Microsoft.YourPhone';
  'Microsoft.MicrosoftEdge';
  'Microsoft.MicrosoftEdge.Stable';
  'Microsoft.MicrosoftEdge_8wekyb3d8bbwe';
  'Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe';
  'Microsoft.MicrosoftEdgeDevToolsClient_1000.19041.1023.0_neutral_neutral_8wekyb3d8bbwe';
  'Microsoft.MicrosoftEdge_44.19041.1266.0_neutral__8wekyb3d8bbwe';
  'Microsoft.OneDrive';
  'Microsoft.MicrosoftEdgeDevToolsClient';
  'Microsoft.549981C3F5F10';
  'Microsoft.MixedReality.Portal';
  'Microsoft.Windows.Ai.Copilot.Provider';
  'Microsoft.WindowsMeetNow';
) | Remove-AppxProvisionedPackage -AllUsers -Online


Clear-Host


Get-WindowsCapability -Online |
Where-Object -FilterScript {
  ($_.Name -split '~')[0] -in @(
    'Browser.InternetExplorer';
    'MathRecognizer';
    'OpenSSH.Client';
    'Microsoft.Windows.PowerShell.ISE';
    'App.Support.QuickAssist';
    'App.StepsRecorder';
  );
} | Remove-WindowsCapability -Online
    
	Clear-Host
  # Enables .NET Framework 3.5
  DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /Source:X:\sources\sxs /LimitAccess
  Clear-Host
  # Configure Maximum Password Age in Windows
  net.exe accounts /maxpwage:UNLIMITED
  
  # Allow Execution of PowerShell Script Files
  Set-ExecutionPolicy -Scope 'LocalMachine' -ExecutionPolicy 'RemoteSigned' -Force
  
  # Groups or splits svchost.exe processes based on the amount of physical memory in the system to optimize performance
  $ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
  Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force
  
  $autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
  If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
      Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
  }
  $icaclsCommand = "icacls `"$autoLoggerDir`" /deny SYSTEM:`"(OI)(CI)F`""
  Invoke-Expression $icaclsCommand | Out-Null
  Clear-Host
  # Disable Defender Auto Sample Submission
  Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction Continue | Out-Null
  
  # Removes Microsoft Edge
  foreach ($line in $lines) {
      if ($line -like '*Architecture : *') {
          $architecture = $line -replace 'Architecture : ',''
          # If the architecture is x64, replace it with amd64
          if ($architecture -eq 'x64') {
              $architecture = 'amd64'
          }
          Write-Host "Architecture: $architecture"
          break
      }
  }
  
  if (-not $architecture) {
      Write-Host "Architecture information not found."
  }
  Remove-Item -Path "C:\Program Files (x86)\Microsoft\Edge" -Recurse -Force -ErrorAction Continue
  Remove-Item -Path "C:\Program Files (x86)\Microsoft\EdgeWebView" -Recurse -Force -ErrorAction Continue
  Remove-Item -Path "C:\Program Files (x86)\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction Continue
  Remove-Item -Path "C:\Program Files (x86)\Microsoft\EdgeCore" -Recurse -Force -ErrorAction Continue
  Remove-Item -Path "C:\Users\Public\Desktop\Microsoft Edge.lnk" -Recurse -Force -ErrorAction Continue
  Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -Recurse -Force -ErrorAction Continue
  Remove-Item -Path "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -Recurse -Force -ErrorAction Continue
  Remove-Item -Path "C:\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" -Recurse -Force -ErrorAction Continue
  if ($architecture -eq 'amd64') {
      $folderPath = Get-ChildItem -Path "C:\Windows\WinSxS" -Filter "amd64_microsoft-edge-webview_31bf3856ad364e35*" -Directory | Select-Object -ExpandProperty FullName
  
      if ($folderPath) {
          & 'takeown' '/f' $folderPath '/r' 
          & icacls $folderPath  "/grant" "$($adminGroup.Value):(F)" '/T' '/C' 
          Remove-Item -Path $folderPath -Recurse -Force 
      } else {
          Write-Host "Folder not found."
      }
  } elseif ($architecture -eq 'arm64') {
      $folderPath = Get-ChildItem -Path "C:\Windows\WinSxS" -Filter "arm64_microsoft-edge-webview_31bf3856ad364e35*" -Directory | Select-Object -ExpandProperty FullName
  
      if ($folderPath) {
          & 'takeown' '/f' $folderPath '/r'
          & icacls $folderPath  "/grant" "$($adminGroup.Value):(F)" '/T' '/C' 
          Remove-Item -Path $folderPath -Recurse -Force 
      } else {
          Write-Host "Folder not found."
      }
  } else {
      Write-Host "Unknown architecture: $architecture"
  }
  & 'takeown' '/f' "C:\Windows\System32\Microsoft-Edge-Webview" '/r' 
  & 'icacls' "C:\Windows\System32\Microsoft-Edge-Webview" '/grant' "$($adminGroup.Value):(F)" '/T' '/C' 
  Remove-Item -Path "C:\Windows\System32\Microsoft-Edge-Webview" -Recurse -Force
  Clear-Host
  # Removes OneDrive
  Remove-Item "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -ErrorAction Continue
  Remove-Item "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.exe" -ErrorAction Continue
  Remove-Item "C:\Windows\System32\OneDriveSetup.exe" -ErrorAction Continue
  Remove-Item "C:\Windows\SysWOW64\OneDriveSetup.exe" -ErrorAction Continue
   
  # Removes Microsoft Teams
  $TeamsPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams')
  $TeamsUpdateExePath = [System.IO.Path]::Combine($TeamsPath, 'Update.exe')
  
  Stop-Process -Name "*teams*" -Force -ErrorAction Continue
  
  if ([System.IO.File]::Exists($TeamsUpdateExePath)) {
      # Uninstall app
      $proc = Start-Process $TeamsUpdateExePath "-uninstall -s" -PassThru
      $proc.WaitForExit()
  }
  
  Get-AppxPackage "*Teams*" | Remove-AppxPackage -ErrorAction Continue
  Get-AppxPackage "*Teams*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction Continue
  
  if ([System.IO.Directory]::Exists($TeamsPath)) {
      Remove-Item $TeamsPath -Force -Recurse -ErrorAction Continue
  }
  Clear-Host
  # Uninstall from Uninstall registry key UninstallString
  $us = (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -like '*Teams*'}).UninstallString
  if ($us.Length -gt 0) {
      $us = ($us.Replace('/I', '/uninstall ') + ' /quiet').Replace('  ', ' ')
      $FilePath = ($us.Substring(0, $us.IndexOf('.exe') + 4).Trim())
      $ProcessArgs = ($us.Substring($us.IndexOf('.exe') + 5).Trim().replace('  ', ' '))
      $proc = Start-Process -FilePath $FilePath -Args $ProcessArgs -PassThru
      $proc.WaitForExit()
  }
  
  # Disables Teredo
  $registryKeysTeredo = @(
      @{Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"; Name = "DisabledComponents"; Type = "DWord"; Value = 1}
  )
  foreach ($key in $registryKeysTeredo) {
      New-ItemProperty -Path $key.Path -Name $key.Name -PropertyType $key.Type -Value $key.Value -Force
  }
  netsh interface teredo set state disabled
	
}

Function Tweaks-Debloat2 {
	#SafeApps contains apps that shouldn't be removed, or just can't and cause errors
	$SafeApps = "AAD.brokerplugin|accountscontrol|apprep.chxapp|assignedaccess|asynctext|bioenrollment|capturepicker|cloudexperience|contentdelivery|desktopappinstaller|ecapp|edge|extension|getstarted|immersivecontrolpanel|lockapp|net.native|oobenet|parentalcontrols|PPIProjection|search|sechealth|secureas|shellexperience|startmenuexperience|terminal|vclibs|xaml|XGpuEject"
	If ($Xbox) {
		$SafeApps = "$SafeApps|Xbox" 
}
	
	If ($Allapps) {
		$RemoveApps = Get-AppxPackage -allusers | where-object {$_.name -notmatch $SafeApps}
		$RemovePrApps = Get-AppxProvisionedPackage -online | where-object {$_.displayname -notmatch $SafeApps}
			ForEach ($RemovedApp in $RemoveApps) {
				Remove-AppxPackage -package $RemovedApp -erroraction silentlycontinue
				
}			ForEach ($RemovedPrApp in $RemovePrApps) {
				Remove-AppxProvisionedPackage -online -packagename $RemovedPrApp.packagename -erroraction silentlycontinue
				
}
}	Else {
		$SafeApps = "$SafeApps|$GoodApps"
		$RemoveApps = Get-AppxPackage -allusers | where-object {$_.name -notmatch $SafeApps}
		$RemovePrApps = Get-AppxProvisionedPackage -online | where-object {$_.displayname -notmatch $SafeApps}
			ForEach ($RemovedApp in $RemoveApps) {
				Remove-AppxPackage -package $RemovedApp -erroraction silentlycontinue
				
}			ForEach ($RemovedPrApp in $RemovePrApps) {
				Remove-AppxProvisionedPackage -online -packagename $RemovedPrApp.packagename -erroraction silentlycontinue
				
}
}
} 

Function Tweaks-StartMenu {
    If ($ClearStart) {
		Write-Host "***Setting empty start menu for new profiles...***"
#Don't edit this. Creates empty start menu if -ClearStart is used.
        $StartLayoutStr = @"
<LayoutModificationTemplate Version="1" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout">
  <LayoutOptions StartTileGroupCellWidth="6" />
  <DefaultLayoutOverride>
    <StartLayoutCollection>
      <defaultlayout:StartLayout GroupCellWidth="6" xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout">
      </defaultlayout:StartLayout>
    </StartLayoutCollection>
  </DefaultLayoutOverride>
  </LayoutModificationTemplate>
"@
	    add-content $Env:TEMP\startlayout.xml $StartLayoutStr
        import-startlayout -layoutpath $Env:TEMP\startlayout.xml -mountpath $Env:SYSTEMDRIVE\
        remove-item $Env:TEMP\startlayout.xml
}    Else {        
		Write-Host "***Setting clean start menu for new profiles...***"
#Custom start layout XML near the top of the script.

        add-content $Env:TEMP\startlayout.xml $StartLayoutStr
        import-startlayout -layoutpath $Env:TEMP\startlayout.xml -mountpath $Env:SYSTEMDRIVE\
        remove-item $Env:TEMP\startlayout.xml
}
}

Function BCD-Tweaks {

	try {
    # Set default boot menu policy to standard
    Start-Process -FilePath "cmd.exe" -ArgumentList '/c bcdedit /set {default} bootmenupolicy standard' -Wait -NoNewWindow -ErrorAction Stop
	Clear-Host
    # Set current boot menu policy to standard
    Start-Process -FilePath "cmd.exe" -ArgumentList '/c bcdedit /set {current} bootmenupolicy standard' -Wait -NoNewWindow -ErrorAction Stop
	Clear-Host
    # Enable highest mode globally
    Start-Process -FilePath "cmd.exe" -ArgumentList '/c bcdedit /set {globalsettings} highestmode true' -Wait -NoNewWindow -ErrorAction Stop
	Clear-Host
} catch {
    Write-Host "Failed to configure boot settings. Ensure you are running as administrator." -ForegroundColor DarkRed
}
return
}

Tweaks-Muchi-Apps
Clear-Host
Tweaks-Muchi-Power-Plan
Clear-Host
Tweaks-PS1-Assoc
Clear-Host
Tweaks-Take-Owner
Clear-Host
Tweaks-Disable-UAC
Clear-Host
Tweaks-Disable-Wifi-Sense
Clear-Host
Tweaks-Disable-Win-Ads
Clear-Host
Tweaks-DVR-Settings
Clear-Host
Tweaks-Game-Mode
Clear-Host
Tweaks-Misc-Tweaks
Clear-Host
Tweaks-Original-Context-Menu
Clear-Host
Tweaks-Performance-Tweaks
Clear-Host
Tweaks-Annoyances
Clear-Host
Tweaks-Sch-Tasks
Clear-Host
Tweaks-Delete-OneDrive
Clear-Host
Tweaks-KBM
Clear-Host
Tweaks-Services
Clear-Host
Tweaks-Debloat1
Clear-Host
Tweaks-Debloat2
Clear-Host
Tweaks-StartMenu
Clear-Host
BCD-Tweaks
Clear-Host

Write-Host "Configuring Windows Update for Security Updates Only..." -ForegroundColor Green

# Define registry paths for Windows Update configurations
$WURegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$AURegistryPath = "$WURegistryPath\AU"

# Ensure the registry keys exist
if (-not (Test-Path $WURegistryPath)) {
    New-Item -Path $WURegistryPath -Force | Out-Null
}
if (-not (Test-Path $AURegistryPath)) {
    New-Item -Path $AURegistryPath -Force | Out-Null
}

# Disable automatic updates except for security updates
Set-ItemProperty -Path $WURegistryPath -Name "DeferFeatureUpdates" -Value 1 -Force
Set-ItemProperty -Path $WURegistryPath -Name "DeferQualityUpdates" -Value 1 -Force
Set-ItemProperty -Path $WURegistryPath -Name "BranchReadinessLevel" -Value 10 -Force # Set to Semi-Annual Channel (Targeted)
Set-ItemProperty -Path $WURegistryPath -Name "DeferQualityUpdatesPeriodInDays" -Value 0 -Force

# Configure AU settings for manual control
Set-ItemProperty -Path $AURegistryPath -Name "NoAutoUpdate" -Value 1 -Force
Set-ItemProperty -Path $AURegistryPath -Name "AUOptions" -Value 2 -Force # Notify for download/install

# Disable driver updates via Windows Update
$DriverPolicyPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching"
if (-not (Test-Path $DriverPolicyPath)) {
    New-Item -Path $DriverPolicyPath -Force | Out-Null
}
Set-ItemProperty -Path $DriverPolicyPath -Name "SearchOrderConfig" -Value 0 -Force

# Optimize Update Settings for Security Updates Only
Write-Host "Applying security-only updates settings..." -ForegroundColor Cyan
Start-Process -FilePath "C:\Windows\System32\schtasks.exe" -ArgumentList "/Delete /TN \"\Microsoft\Windows\WindowsUpdate\Automatic App Update\" /F" -NoNewWindow -Wait

Write-Host "Configuration complete. Restart your computer for full effect." -ForegroundColor Green

Write-Host "All Tweaks Are Finished!"
Write-Host ""
Write-Host "Closing In 3....."
Start-Sleep -Seconds 4
Exit
