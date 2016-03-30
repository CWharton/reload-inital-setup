set WshShell = WScript.CreateObject("WScript.Shell")
strDesktop = WshShell.SpecialFolders("AllUsersDesktop")
strFavorites = WshShell.SpecialFolders("AllUsersDesktop") & "\..\Favorites"

'Automax Ups System
set oUrlLink_UPs = WshShell.CreateShortcut(strDesktop & "\Automax Ups System.url")
oUrlLink_UPs.TargetPath = "http://10.18.210.7/ups"
oUrlLink_UPs.Save

'Automax Ups System (Favorites)
set oUrlLink_UPs = WshShell.CreateShortcut(strFavorites & "\Automax Ups System.url")
oUrlLink_UPs.TargetPath = "http://10.18.210.7/ups"
oUrlLink_UPs.Save

'DealerTrack
set oUrlLink_UPs = WshShell.CreateShortcut(strDesktop & "\DealerTrack.url")
oUrlLink_UPs.TargetPath = "https://www.dealertrack.com/public/login.fcc"
oUrlLink_UPs.Save

'DealerTrack (Favorites)
set oUrlLink_UPs = WshShell.CreateShortcut(strFavorites & "\DealerTrack.url")
oUrlLink_UPs.TargetPath = "https://www.dealertrack.com/public/login.fcc"
oUrlLink_UPs.Save

'V Auto
set oUrlLink_UPs = WshShell.CreateShortcut(strDesktop & "\VAuto.url")
oUrlLink_UPs.TargetPath = "https://www2.vauto.com/"
oUrlLink_UPs.Save

'V Auto (Favorites)
set oUrlLink_UPs = WshShell.CreateShortcut(strFavorites & "\VAuto.url")
oUrlLink_UPs.TargetPath = "https://www2.vauto.com/"
oUrlLink_UPs.Save

'FmcDealer Site
set oUrlLink_UPs = WshShell.CreateShortcut(strDesktop & "\FMCDealer.url")
oUrlLink_UPs.TargetPath = "http://fmcdealer.com/"
oUrlLink_UPs.Save

'Hundai Dealer Site
set oUrlLink_UPs = WshShell.CreateShortcut(strDesktop & "\HyundaiDealer.url")
oUrlLink_UPs.TargetPath = "http://hyundaidealer.com/"
oUrlLink_UPs.Save

'VW Hub Site
set oUrlLink_UPs = WshShell.CreateShortcut(strDesktop & "\vwhub.url")
oUrlLink_UPs.TargetPath = "http://vwhub.com/"
oUrlLink_UPs.Save

'VW Hub (Favorites)
set oUrlLink_UPs = WshShell.CreateShortcut(strFavorites & "\vwhub.url")
oUrlLink_UPs.TargetPath = "http://vwhub.com/"

'Dealer Sockett
set oUrlLink_UPs = WshShell.CreateShortcut(strDesktop & "\dealersocket.url")
oUrlLink_UPs.TargetPath = "https://my.dealersocket.com/"
oUrlLink_UPs.Save