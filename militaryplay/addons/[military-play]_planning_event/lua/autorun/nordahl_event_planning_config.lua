nordahl_cfg_1524 = nordahl_cfg_1524 or {}
--------------------------------------------------------------VERSION---------------------------------------------------------
local Ver="2.8"
if NCS_VER==nil then
NCS_VER={}
NCS_VER["nordahl_planning_event"]=Ver
else
NCS_VER["nordahl_planning_event"]=Ver
end
--------------------------------------------------------------nordahl_cfg_1524URATION---------------------------------------------------------
nordahl_cfg_1524.OwnerSteamID="STEAM_0:0:00000000000" --"STEAM_0:1:36759270" --If you are the owner and you dont use Admin System put your Steam ID here. Value exemple: ---> "STEAM_0:1:125347606"
nordahl_cfg_1524.F1_to_Open_the_planning=0 --0 = Disable, Player Can open if he press F1 is the value is = 1. 
nordahl_cfg_1524.Allow_Admin=1
nordahl_cfg_1524.Allow_SUPER_Admin=1
nordahl_cfg_1524.Allow_ULX_GROUP_CAN_ACCESS_PANEL={"superadmin","admin"} --Add ULX Admin Group if you want add "admin" ULX rank and another {"superadmin","admin","anothergroup"}
nordahl_cfg_1524.SERVERGUARD_Access_rank={"founder","admin"} --Add ServerGuard Admin Group if you want add "admin" {"superadmin","admin","anothergroup"} if you dont have Server Guard installed keep it empty.
nordahl_cfg_1524.Allow_JOB_CAN_CHANGE_EVENTPLANNING={} -- In this exemple Mayor can add players in white list Job Can add player in whitelist do like it if you wan tadd more follow this exemple: {"Mayor","Anotherjob","Anotherjob"} to keep it empty like it: {}
nordahl_cfg_1524.USeWorkshopContent=1 --If you dont have a fastdownload you can use workshop content (1 Enable "I want use workshop" / 0 Disable "I prefer use my fastdl")
nordahl_cfg_1524.Enable_Notifsound_Event=1
nordahl_cfg_1524.Notifsound="ambient/alarms/warningbell1.wav" --Replace if you want by another sound
nordahl_cfg_1524.UTC_GMT=0 -- UTC/GMT default value is GMT+0 he can be -12 & +12
nordahl_cfg_1524.IN_CONTEXTMENU=0
/* nordahl_cfg_1524.IN_CONTEXTMENU
0= Disabled
1= The memo is draw only when you press contextmenu (Q)
*/
--new in version 2.7
nordahl_cfg_1524.DURATION_HUD_NOTIFY=3600 --Time of message is show in HUD, 60 Seconds by default

---DONT TOUCH THIS CONFIG---------------------------------------------------------
nordahl_cfg_1524.Heure=0
nordahl_cfg_1524.min=0
nordahl_cfg_1524.sec=0
nordahl_cfg_1524.txtheure="0"
nordahl_cfg_1524.txtminute="0"
nordahl_cfg_1524.Jour="1"
nordahl_cfg_1524.Group="1"

print("Nordahl - Event Planning Editor - Config Ok")
