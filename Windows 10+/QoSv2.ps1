# Script for delete all QOS Policy and create new.
# All DSCP marks is Cake diffserv4 friendly.
# Clear All Policy
    Remove-NetQosPolicy -Name "*"
    Start-Sleep -Seconds 2

# Create QoS Policys
#Games
    New-NetQosPolicy -Name "Games-Overwatch" -AppPathName "Overwatch.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 46
    New-NetQosPolicy -Name "Games-OverwatchL" -AppPathName "Overwatch Launcher.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 46
    New-NetQosPolicy -Name "Games-QuakeChampions" -AppPathName "QuakeChampions.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 46
    New-NetQosPolicy -Name "Games-TheFinals" -AppPathName "Discovery.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 46
    New-NetQosPolicy -Name "Games-NyanHeroes" -AppPathName "nyanheroes-win64-shipping.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 46
    New-NetQosPolicy -Name "Games-Once_human" -AppPathName "once_human.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 46
    New-NetQosPolicy -Name "Games-Rust" -AppPathName "Rust.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 46
    New-NetQosPolicy -Name "Games-RustClient" -AppPathName "RustClient.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 46
#OBS
    New-NetQosPolicy -Name "OBS" -AppPathName "obs64.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 34
#Battle.net
    New-NetQosPolicy -Name "Market-Battle.net" -AppPathName "Battle.net.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-Battle.net Launcher" -AppPathName "Battle.net Launcher.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-Battle.net Agent" -AppPathName "Agent.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#EA Desktop (Origin) NEW
    New-NetQosPolicy -Name "Market-EA Desktop Market" -AppPathName "EADesktop.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-EA Desktop DownloadSVC" -AppPathName "EABackgroundService.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#Steam
    New-NetQosPolicy -Name "Market-Steam" -AppPathName "Steam.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-SteamwebHelper" -AppPathName "steamwebhelper.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-Steamerrorreporter64" -AppPathName "steamerrorreporter64.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-Steamerrorreporter" -AppPathName "steamerrorreporter.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#EGS
    New-NetQosPolicy -Name "Market-EpicGamesLauncher" -AppPathName "EpicGamesLauncher.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-GenshinLauncher" -AppPathName "Launcher.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-GenshinEpicLauncher" -AppPathName "launcher_epic.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#UbiSoft Store
    New-NetQosPolicy -Name "Market-UbisoftGameLauncher" -AppPathName "UbisoftGameLauncher.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-UbisoftGameLauncher64" -AppPathName "UbisoftGameLauncher64.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-Upc" -AppPathName "upc.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Market-UplayWebCore" -AppPathName "UplayWebCore.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#VKPlay
    New-NetQosPolicy -Name "Market-VKPlay" -AppPathName "gamecenter.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#Web Browser
#    New-NetQosPolicy -Name "WEB-WebBrowser" -AppPathName "WebBrowser.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 14
#    New-NetQosPolicy -Name "WEB-UpdaterForBrowser" -AppPathName "Updater.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#qbittorrent
    New-NetQosPolicy -Name "Torrent-qbittorrent" -AppPathName "qbittorrent.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#Download Manager
    New-NetQosPolicy -Name "Download-Aria2c" -AppPathName "aria2c.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Download-Aria2" -AppPathName "aria2.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Download-PersepolisDM" -AppPathName "Persepolis Download Manager.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "Download-PersepolisDM2" -AppPathName "PersepolisBI.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#Portableappsupdater ( portableapps.com )
    New-NetQosPolicy -Name "Download-PortableAPPSupdater" -AppPathName "portableappsupdater.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#WindowsUpdate+Store+XBOX
#   (this break mangle marks by ports in router for DNS, DHCP etc) New-NetQosPolicy -Name "WinServ-svchost" -AppPathName "svchost.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "WinServ-WinStore" -AppPathName "WinStore.App.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "WinServ-StartMenuExperienceHost" -AppPathName "StartMenuExperienceHost.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "WinServ-Xbox" -AppPathName "XboxPcApp.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
#
    New-NetQosPolicy -Name "WinServ-SystemSettings" -AppPathName "systemsettings.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "WinServ-msmpeng" -AppPathName "msmpeng.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "WinServ-mpcmdrun" -AppPathName "mpcmdrun.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "WinServ-mpdefendercoreservice" -AppPathName "mpdefendercoreservice.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "WinServ-microsoftedgeupdate" -AppPathName "microsoftedgeupdate.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8
    New-NetQosPolicy -Name "WinServ-googleupdate" -AppPathName "googleupdate.exe" -NetworkProfile All -IPProtocol Both -DSCPValue 8

    Start-Sleep -Seconds 2
#Force update Group Poliy - NOW!
    Gpupdate.exe /force
    Start-Sleep -Seconds 2

# FullTable   Get-NetQoSPolicy | Format-Table Name,AppPathName,NetworkProfile,IPProtocol,IPDstPort,IPDstPortStart,IPDstPortEnd,DSCPValue
    Get-NetQoSPolicy | Format-Table Name,AppPathName,NetworkProfile,IPProtocol,DSCPValue
pause
