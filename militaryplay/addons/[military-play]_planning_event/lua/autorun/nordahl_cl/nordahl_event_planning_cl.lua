
/* READ THIS BEFORE HAVE PROBLEM PLEASE,

If you find my work serious know they are all my other scripts here: https://scriptfodder.com/users/view/76561198033784269/scripts
I'm not only an simple coder you can see and support my creativity:

My Facebook Page: https://www.facebook.com/zworld.afterlife/
My Drawing: http://www.zworld-afterlife.com/?pid=3
My Steam Group: http://steamcommunity.com/groups/zworld-afterlife
My servers here: http://www.zworld-afterlife.com/?pid=3


----1.Script Activation & antileak----
Tout ce que tu dois savoir: http://www.zworld-afterlife.com/f8-128273-nordahl-s-script-protection-systeme-d-activation-de-scriptes
All you must know:  http://www.zworld-afterlife.com/f11-128273-nordahl-s-script-protection-system-s-scripts-activation

----2.Leak----
Our biggest issues here are people who purchase scripts, with the sole purpose of leaking them.
As a developer, if I see my scripts, or any other developer's scripts here for that matter leaked by a member of the ScriptFodder community,
rest assured that I will do everything in my power to ensure you fail.
This includes but not limited to, notifying a moderator / admin of ScriptFodder of your attempt to leak,
with proof of course (because we will find you); ensuring you are banned from the website.
Your access to my script completely revoked without any additional warning.
Your name publicly blasted, with SteamID, on any and all developer forums, including Facepunch.com.
As well as any Steam groups you may be part of (maybe even your friends).
And finally, a phone call to PayPal explaining who you are, and what you are attempting to do.
Which in the future can jeopardize your very own PayPal account and have it limited.
We are developers, this is partially how we make a living, and it helps support our families.
If you have an issue, simply tell me and I'll do everything in my power to fix it.
Attempting charge-backs is not the way to handle a business transaction.
If you are not a leaker, you have nothing to worry about, and I thank you for your purchase.

Keep in mind. The leak destroys the creation and the opportunity to see something new and different on Gmod.

----3.Copyright----
The Zworld-Afterlife scripts are placed at Copyright France since 2012.
zworld-afterlife.com© 2008-2015. Created by Nordahl
Do not publish without my authorization.

With my regards,
Thank You.

By Nordahl                                                                                                                                                                                                                                                                     76561197989007643 
If you find my work serious know they are all my other scripts here: https://scriptfodder.com/users/view/76561198033784269/scripts
*/

local scriptlink="1524"
local puce="*"

local CONFIG=nordahl_cfg_1524
local Mommrk=CurTime()
local duration=CONFIG.DURATION_HUD_NOTIFY
local function eRight(a)
if a:SteamID()==CONFIG.OwnerSteamID then return true end
if a:IsAdmin()==true then if CONFIG.Allow_Admin==1 then return true end end
if a:IsSuperAdmin()==true then if CONFIG.Allow_SUPER_Admin==1 then return true end end
for _,c in ipairs(CONFIG.Allow_ULX_GROUP_CAN_ACCESS_PANEL)do if a:IsUserGroup(c) then return true end end
for _,c in ipairs(CONFIG.Allow_JOB_CAN_CHANGE_EVENTPLANNING)do if c==team.GetName( a:Team() ) then return true end end
if serverguard then for _,c in ipairs(CONFIG.SERVERGUARD_Access_rank)do if serverguard.player:GetRank(a)==c then return true end end end
return false
end

local openmenu=false

local files=file.Read("nordahlclient_option/language.txt","DATA")
if (!files) then
file.CreateDir("nordahlclient_option")
file.Write("nordahlclient_option/language.txt","2")
Z_Defaut_Languages=2
else
Z_Defaut_Languages=tonumber(file.Read("nordahlclient_option/language.txt","DATA"))
end

local tra_scrp_nordahl = "PLANNING"
local tra_scrp_nordahl_e = "Delete"
local tra_scrp_nordahl_lun = "Monday"
local tra_scrp_nordahl_mar = "Tuesday"
local tra_scrp_nordahl_mer = "Wednesday"
local tra_scrp_nordahl_jeu = "Thursday"
local tra_scrp_nordahl_ven = "Friday"
local tra_scrp_nordahl_sam = "Saturday"
local tra_scrp_nordahl_dim = "Sunday"
local tra_scrp_nordahl_heure = "Hours"
local tra_scrp_nordahl_minute = "Minutes"
local tra_scrp_nordahl_heurere = "Real"
local tra_scrp_nordahl_heurevi = "Virtual"
local tra_scrp_nordahl_SH = "Time System"
local tra_scrp_nordahl_Time = "Changing the time"
local tra_scrp_nordahl_Cons = "in the Console"
local tra_scrp_nordahl_Groupmax = "Number Group"
local tra_scrp_nordahl_script = "Script"
local tra_scrp_nordahl_credit = "Made by Nordahl"
local tra_scrp_nordahl_ng = "Rename group"
local tra_scrp_nordahl_settime = "Virtual Conversion Time"
local tra_scrp_nordahl_noevent="There are currently no events, check the planning"
local tra_scrp_nordahl_titre="Planning of the Server: "
local tra_scrp_nordahl_only="Only Show In Event"
local tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
local tra_scrp_actue="Currently"
local tra_scrp_proch="In the Next hour"

function langueeventplen(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "PLANNING"
tra_scrp_nordahl_e = "Delete"
tra_scrp_nordahl_lun = "Monday"
tra_scrp_nordahl_mar = "Tuesday"
tra_scrp_nordahl_mer = "Wednesday"
tra_scrp_nordahl_jeu = "Thursday"
tra_scrp_nordahl_ven = "Friday"
tra_scrp_nordahl_sam = "Saturday"
tra_scrp_nordahl_dim = "Sunday"
tra_scrp_nordahl_heure = "Hours"
tra_scrp_nordahl_minute = "Minutes"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "Virtual"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "Changing the time"
tra_scrp_nordahl_Cons = "in the Console"
tra_scrp_nordahl_Groupmax = "Number Group"
tra_scrp_nordahl_script = "Script"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Rename group"
tra_scrp_nordahl_settime = "Virtual Conversion Time"
tra_scrp_nordahl_noevent="There are currently no events, check the planning"
tra_scrp_nordahl_titre="Planning of the Server: "
tra_scrp_nordahl_only="Only Show In Event"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue="Currently"
tra_scrp_proch="In the Next hour"
end

function langueeventpldu(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "Planung" 
tra_scrp_nordahl_e = "Löschen" 
tra_scrp_nordahl_lun = "Montag" 
tra_scrp_nordahl_mar = "Dienstag" 
tra_scrp_nordahl_mer = "Mittwoch" 
tra_scrp_nordahl_jeu = "Donnerstag" 
tra_scrp_nordahl_ven = "Freitag" 
tra_scrp_nordahl_sam = "Samstag" 
tra_scrp_nordahl_dim = "Sonntag" 
tra_scrp_nordahl_heure = "Stunden" 
tra_scrp_nordahl_minute = "Minuten" 
tra_scrp_nordahl_heurere = "Real" 
tra_scrp_nordahl_heurevi = "Virtuelle" 
tra_scrp_nordahl_SH = "Zeit System" 
tra_scrp_nordahl_Time = "Ändern der Zeit" 
tra_scrp_nordahl_Cons = "in die Konsole schreiben" 
tra_scrp_nordahl_Groupmax = "Anzahl Gruppen" 
tra_scrp_nordahl_script = "Script" 
tra_scrp_nordahl_credit = "von Nordahl" 
tra_scrp_nordahl_ng = "Gruppe umbenennen" 
tra_scrp_nordahl_settime = "Virtuelle Conversion Time" 
tra_scrp_nordahl_noevent="Es liegen noch keine Events an, überprüfen Sie den Zeitplan" 
tra_scrp_nordahl_titre="Server Eventplanung:" 
tra_scrp_nordahl_only="Nur bei Events zeigen"
tra_scrp_nordahl_only_inctxtmenu="Nur anzeigen, wenn die menucontext geöffnet ist"
tra_scrp_actue = "Currently"
tra_scrp_proch = "In the Next hour"
end

function langueeventplru(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "Планирование"
tra_scrp_nordahl_e = "Удалить"
tra_scrp_nordahl_lun = "Понедельник"
tra_scrp_nordahl_mar = "Вторник"
tra_scrp_nordahl_mer = "Среда"
tra_scrp_nordahl_jeu = "Четверг"
tra_scrp_nordahl_ven = "Пятница"
tra_scrp_nordahl_sam = "Суббота"
tra_scrp_nordahl_dim = "Воскресенье"
tra_scrp_nordahl_heure = "Часы"
tra_scrp_nordahl_minute = "минут"
tra_scrp_nordahl_heurere = "Реал"
tra_scrp_nordahl_heurevi = "Виртуальная"
tra_scrp_nordahl_SH = "Системное время"
tra_scrp_nordahl_Time = "Изменение времени"
tra_scrp_nordahl_Cons = "в консоли"
tra_scrp_nordahl_Groupmax = "Номер группы"
tra_scrp_nordahl_script = "Кредит"
tra_scrp_nordahl_credit = "Сделано Нордалем"
tra_scrp_nordahl_ng = "Переименовать группу"
tra_scrp_nordahl_settime = "Виртуальная время преобразования"
tra_scrp_nordahl_noevent="Нет мероприятий"
tra_scrp_nordahl_titre="Планирование событий сервера:"
tra_scrp_nordahl_only="Only Show In Event"
tra_scrp_nordahl_only_inctxtmenu="Показываем только когда menucontext открыт"
tra_scrp_actue = "В настоящее время"
tra_scrp_proch = "В течение следующего часа"
end

function langueeventples(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "PLANIFICACIÓN"
tra_scrp_nordahl_e = "Borrar"
tra_scrp_nordahl_lun = "Lunes"
tra_scrp_nordahl_mar = "Martes"
tra_scrp_nordahl_mer = "Miércoles"
tra_scrp_nordahl_jeu = "Jueves"
tra_scrp_nordahl_ven = "Viernes"
tra_scrp_nordahl_sam = "Sábado"
tra_scrp_nordahl_dim = "Domingo"
tra_scrp_nordahl_heure = "Horas"
tra_scrp_nordahl_minute = "Minutos"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "virtual"
tra_scrp_nordahl_SH = "System Time"
tra_scrp_nordahl_Time = "Cambio de la hora"
tra_scrp_nordahl_Cons = "en la consola"
tra_scrp_nordahl_Groupmax = "Grupo Número"
tra_scrp_nordahl_script = "Crédito"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Cambiar el nombre de grupo"
tra_scrp_nordahl_settime = "virtual Tiempo de Conversión"
tra_scrp_nordahl_noevent="Actualmente no hay eventos, revisar el calendario"
tra_scrp_nordahl_titre="La planificación de eventos de servidor"
tra_scrp_nordahl_only="Only Show In Event"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "En la actualidad"
tra_scrp_proch = "En la hora siguiente"
end

function langueeventplfr(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl="PLANNING"
tra_scrp_nordahl_e="Supprimer"
tra_scrp_nordahl_lun="Lundi"
tra_scrp_nordahl_mar="Mardi"
tra_scrp_nordahl_mer="Mercredi"
tra_scrp_nordahl_jeu="Jeudi"
tra_scrp_nordahl_ven="Vendredi"
tra_scrp_nordahl_sam="Samedi"
tra_scrp_nordahl_dim="Dimanche"
tra_scrp_nordahl_heure="Heures"
tra_scrp_nordahl_minute="Minutes"
tra_scrp_nordahl_heurere="Réel"
tra_scrp_nordahl_heurevi="Virtuel"
tra_scrp_nordahl_SH="Système horaire"
tra_scrp_nordahl_Time="Modification du temps"
tra_scrp_nordahl_Cons="dans la Console"
tra_scrp_nordahl_Groupmax="Nombre de Groupe"
tra_scrp_nordahl_script="Script"
tra_scrp_nordahl_credit="Fait par Nordahl"
tra_scrp_nordahl_ng="Renommer les groupes"
tra_scrp_nordahl_settime="Conversion Heure virtuel"
tra_scrp_nordahl_noevent="Il n'y a actuellement pas d'event, vérifier le planning"
tra_scrp_nordahl_titre="Planning du Serveur"
tra_scrp_nordahl_only="Seulement montrer pendant Event"
tra_scrp_nordahl_only_inctxtmenu="Seulement montrer lorsque le menu context est ouvert"
tra_scrp_actue="Actuellement"
tra_scrp_proch="Prochaine heure"
 end

function langueeventplel(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "σχεδιασμός"
tra_scrp_nordahl_e = "Διαγραφή"
tra_scrp_nordahl_lun = "Δευτέρα"
tra_scrp_nordahl_mar = "Τρίτη"
tra_scrp_nordahl_mer = "Τετάρτη"
tra_scrp_nordahl_jeu = "Πέμπτη"
tra_scrp_nordahl_ven = "Παρασκευή"
tra_scrp_nordahl_sam = "Σάββατο"
tra_scrp_nordahl_dim = "Κυριακή"
tra_scrp_nordahl_heure = "Hours"
tra_scrp_nordahl_minute = "Πρακτικά"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "Εικονική"
tra_scrp_nordahl_SH = "System Time"
tra_scrp_nordahl_Time = "Αλλαγή του χρόνου"
tra_scrp_nordahl_Cons = "στην Κονσόλα"
tra_scrp_nordahl_Groupmax = "Ομάδα Αριθμός"
tra_scrp_nordahl_script = "Script"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Μετονομασία ομάδα"
tra_scrp_nordahl_settime = "Εικονική χρόνος μετατροπής"
tra_scrp_nordahl_noevent = "Δεν υπάρχουν γεγονότα, ελέγξτε το σχεδιασμό"
tra_scrp_nordahl_titre = "Σχεδιασμός για Εκδηλώσεις Server"
tra_scrp_nordahl_only = "Δείξε μόνο σε Εκδήλωση"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "Σήμερα"
tra_scrp_proch = "στην επόμενη ώρα"
end
function langueeventplpt(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "planejamento"
tra_scrp_nordahl_e = "Excluir"
tra_scrp_nordahl_lun = "Monday"
tra_scrp_nordahl_mar = "terça-feira"
tra_scrp_nordahl_mer = "Wednesday"
tra_scrp_nordahl_jeu = "Quinta-feira"
tra_scrp_nordahl_ven = "Friday"
tra_scrp_nordahl_sam = "Saturday"
tra_scrp_nordahl_dim = "Sunday"
tra_scrp_nordahl_heure = "Horas"
tra_scrp_nordahl_minute = "Minutes"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "virtual"
tra_scrp_nordahl_SH = "System Time"
tra_scrp_nordahl_Time = "Alterar a hora"
tra_scrp_nordahl_Cons = "no Console"
tra_scrp_nordahl_Groupmax = "Grupo Number"
tra_scrp_nordahl_script = "Crédito"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "grupo Renomear"
tra_scrp_nordahl_settime = "Tempo de conversão virtual"
tra_scrp_nordahl_noevent = "Atualmente não há eventos, verificar o planejamento"
tra_scrp_nordahl_titre = "Planejamento para eventos do servidor"
tra_scrp_nordahl_only = "único show na Event"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "Atualmente"
tra_scrp_proch = "Na próxima hora"
end
function langueeventplpl(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "Planowanie"
tra_scrp_nordahl_e = "Usuń"
tra_scrp_nordahl_lun = "Poniedziałek"
tra_scrp_nordahl_mar = "wtorek"
tra_scrp_nordahl_mer = "środa"
tra_scrp_nordahl_jeu = "czwartek"
tra_scrp_nordahl_ven = "piątek"
tra_scrp_nordahl_sam = "sobota"
tra_scrp_nordahl_dim = "niedziela"
tra_scrp_nordahl_heure = "Godziny"
tra_scrp_nordahl_minute = "Minutes"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "wirtualnej"
tra_scrp_nordahl_SH = "System Time"
tra_scrp_nordahl_Time = "Zmiana czasu"
tra_scrp_nordahl_Cons = "w konsoli"
tra_scrp_nordahl_Groupmax = "Liczba Group"
tra_scrp_nordahl_script = "Kredyt"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Zmiana nazwy grupy"
tra_scrp_nordahl_settime = "Wirtualny czas konwersji"
tra_scrp_nordahl_noevent = "Obecnie nie ma żadnych zdarzeń, sprawdź planowania"
tra_scrp_nordahl_titre = "Planowanie dla serwera zdarzeń"
tra_scrp_nordahl_only = "Pokaż tylko w turnieju"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "Obecnie"
tra_scrp_proch = "W ciągu następnej godziny"
end
function langueeventplit(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "PIANIFICAZIONE"
tra_scrp_nordahl_e = "Cancella"
tra_scrp_nordahl_lun = "Lunedi"
tra_scrp_nordahl_mar = "Martedì"
tra_scrp_nordahl_mer = "Mercoledì"
tra_scrp_nordahl_jeu = "Giovedi"
tra_scrp_nordahl_ven = "Venerdì"
tra_scrp_nordahl_sam = "Sabato"
tra_scrp_nordahl_dim = "Domenica"
tra_scrp_nordahl_heure = "Ore"
tra_scrp_nordahl_minute = "minuti"
tra_scrp_nordahl_heurere = "reale"
tra_scrp_nordahl_heurevi = "virtuale"
tra_scrp_nordahl_SH = "System Time"
tra_scrp_nordahl_Time = "Modifica del tempo"
tra_scrp_nordahl_Cons = "nella console"
tra_scrp_nordahl_Groupmax = "Gruppo di Numero"
tra_scrp_nordahl_script = "Credito"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Rinomina gruppo"
tra_scrp_nordahl_settime = "Tempo virtuale di conversione"
tra_scrp_nordahl_noevent = "Al momento non ci sono eventi, controllare la pianificazione"
tra_scrp_nordahl_titre = "Pianificazione per eventi del server"
tra_scrp_nordahl_only = "Solo Show di eventi"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "Attualmente"
tra_scrp_proch = "Nella prossima ora"
end
function langueeventplbg(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "ПЛАНИРАНЕ"
tra_scrp_nordahl_e = "Изтриване"
tra_scrp_nordahl_lun = "Понеделник"
tra_scrp_nordahl_mar = "вторник"
tra_scrp_nordahl_mer = "сряда"
tra_scrp_nordahl_jeu = "четвъртък"
tra_scrp_nordahl_ven = "петък"
tra_scrp_nordahl_sam = "събота"
tra_scrp_nordahl_dim = "неделя"
tra_scrp_nordahl_heure = "часа"
tra_scrp_nordahl_minute = "Протокол"
tra_scrp_nordahl_heurere = "Реал"
tra_scrp_nordahl_heurevi = "Virtual"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "Промяна на времето"
tra_scrp_nordahl_Cons = "в конзолата"
tra_scrp_nordahl_Groupmax = "Брой Група"
tra_scrp_nordahl_script = "кредит"
tra_scrp_nordahl_credit = "Произведено от Nordahl"
tra_scrp_nordahl_ng = "Преименуване на група"
tra_scrp_nordahl_settime = "Virtual Time Преобразуване"
tra_scrp_nordahl_noevent = "В момента няма събития, проверка на планирането"
tra_scrp_nordahl_titre = "Планиране на събития в сървъра"
tra_scrp_nordahl_only = "показва само в Събитие"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "В момента"
tra_scrp_proch = "В следващия час"
end
function langueeventplcs(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "plánování"
tra_scrp_nordahl_e = "Delete"
tra_scrp_nordahl_lun = "pondělí"
tra_scrp_nordahl_mar = "úterý"
tra_scrp_nordahl_mer = "středu"
tra_scrp_nordahl_jeu = "čtvrtku"
tra_scrp_nordahl_ven = "pátek"
tra_scrp_nordahl_sam = "Saturday"
tra_scrp_nordahl_dim = "neděle"
tra_scrp_nordahl_heure = "Hodiny"
tra_scrp_nordahl_minute = "Minutes"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "virtuální"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "Změna času"
tra_scrp_nordahl_Cons = "v konzole"
tra_scrp_nordahl_Groupmax = "Číslo skupiny"
tra_scrp_nordahl_script = "úvěr"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Přejmenovat skupinu"
tra_scrp_nordahl_settime = "Virtuální Time Conversion"
tra_scrp_nordahl_noevent = "Momentálně nejsou žádné události, podívejte se na plánování"
tra_scrp_nordahl_titre = "Plánování události serveru"
tra_scrp_nordahl_only = "zobrazoval pouze z události"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "V současné době"
tra_scrp_proch = "V další hodině"
end
function langueeventplet(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "planeerimine"
tra_scrp_nordahl_e = "Kustuta"
tra_scrp_nordahl_lun = "esmaspäev"
tra_scrp_nordahl_mar = "Teisipäev"
tra_scrp_nordahl_mer = "WEDNESDAY"
tra_scrp_nordahl_jeu = "Neljapäev"
tra_scrp_nordahl_ven = "reede"
tra_scrp_nordahl_sam = "Saturday"
tra_scrp_nordahl_dim = "Sunday"
tra_scrp_nordahl_heure = "tundi"
tra_scrp_nordahl_minute = "Protokoll"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "virtuaalsed"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "Muutuv aeg"
tra_scrp_nordahl_Cons = "Console"
tra_scrp_nordahl_Groupmax = "number rühm"
tra_scrp_nordahl_script = "Script"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Nimeta grupp ümber"
tra_scrp_nordahl_settime = "Virtual Conversion Time"
tra_scrp_nordahl_noevent = "Hetkel ei ole sündmusi, kontrollige planeerimine"
tra_scrp_nordahl_titre = "Planeerimine Server Events"
tra_scrp_nordahl_only = "näidatakse ainult Event"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "Praegu"
tra_scrp_proch = "järgmine tund"
end
function langueeventplfi(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "suunnittelu"
tra_scrp_nordahl_e = "Poista"
tra_scrp_nordahl_lun = "maanantai"
tra_scrp_nordahl_mar = "tiistai"
tra_scrp_nordahl_mer = "keskiviikko"
tra_scrp_nordahl_jeu = "torstai"
tra_scrp_nordahl_ven = "perjantai"
tra_scrp_nordahl_sam = "Saturday"
tra_scrp_nordahl_dim = "Sunday"
tra_scrp_nordahl_heure = "Hours"
tra_scrp_nordahl_minute = "Minutes"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "Virtuaalinen"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "muuttaminen aika"
tra_scrp_nordahl_Cons = "konsolin"
tra_scrp_nordahl_Groupmax = "Number Group"
tra_scrp_nordahl_script = "Script"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Nimeä ryhmä"
tra_scrp_nordahl_settime = "Virtual Conversion Time"
tra_scrp_nordahl_noevent = "Tällä hetkellä ei tapahtumia, tarkista suunnittelu"
tra_scrp_nordahl_titre = "Suunnittelu Server Events"
tra_scrp_nordahl_only = "Näytä vain In Event"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "Tällä hetkellä"
tra_scrp_proch = "seuraavan tunnin"
end
function langueeventplja(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl="PLANNING"
tra_scrp_nordahl_e="削除"
tra_scrp_nordahl_lun="月曜日"
tra_scrp_nordahl_mar="火曜日"
tra_scrp_nordahl_mer="水曜日"
tra_scrp_nordahl_jeu="木曜日"
tra_scrp_nordahl_ven="金曜日"
tra_scrp_nordahl_sam="土曜日"
tra_scrp_nordahl_dim="日曜日"
tra_scrp_nordahl_heure="時間"
tra_scrp_nordahl_minute="分"
tra_scrp_nordahl_heurere="リアルタイム"
tra_scrp_nordahl_heurevi="仮想"
tra_scrp_nordahl_SH="タイムシステム"
tra_scrp_nordahl_Time="時間の変更します"
tra_scrp_nordahl_Cons="コンソールで"
tra_scrp_nordahl_Groupmax="番号グループ"
tra_scrp_nordahl_script="クレジット"
tra_scrp_nordahl_credit="Nordahl製"
tra_scrp_nordahl_ng="グループの名前を変更します"
tra_scrp_nordahl_settime="仮想変換時間"
tra_scrp_nordahl_noevent="現在、イベント、企画をご確認はありません"
tra_scrp_nordahl_titre="サーバイベントの計画"
tra_scrp_nordahl_only="オンリーイベントで表示します"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue="現在"
tra_scrp_proch="次の時間で"
end
function langueeventplko(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "계획"
tra_scrp_nordahl_e = "삭제"
tra_scrp_nordahl_lun = "월요일"
tra_scrp_nordahl_mar = "화요일"
tra_scrp_nordahl_mer = "수요일"
tra_scrp_nordahl_jeu = "목요일"
tra_scrp_nordahl_ven = "금요일"
tra_scrp_nordahl_sam = "토요일"
tra_scrp_nordahl_dim = "일요일"
tra_scrp_nordahl_heure = "시간"
tra_scrp_nordahl_minute = "분"
tra_scrp_nordahl_heurere = "진짜"
tra_scrp_nordahl_heurevi = "가상"
tra_scrp_nordahl_SH = "시간 시스템"
tra_scrp_nordahl_Time= "시간 변경"
tra_scrp_nordahl_Cons = "콘솔에서"
tra_scrp_nordahl_Groupmax = "숫자 그룹"
tra_scrp_nordahl_script = "신용"
tra_scrp_nordahl_credit = "Nordahl에 의해 만들어"
tra_scrp_nordahl_ng = "그룹 이름 바꾸기"
tra_scrp_nordahl_settime = "가상 변환 시간"
tra_scrp_nordahl_noevent = "현재 어떤 이벤트 계획을 확인이 없습니다"
tra_scrp_nordahl_titre = "서버 이벤트 계획"
tra_scrp_nordahl_only = "만 이벤트에보기"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "현재"
tra_scrp_proch = "다음 시간에"
end
function langueeventpllv(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "plānošana"
tra_scrp_nordahl_e = "Dzēst"
tra_scrp_nordahl_lun = "pirmdiena"
tra_scrp_nordahl_mar = "otrdiena"
tra_scrp_nordahl_mer = "trešdiena"
tra_scrp_nordahl_jeu = "ceturtdiena"
tra_scrp_nordahl_ven = "piektdienas"
tra_scrp_nordahl_sam = "Saturday"
tra_scrp_nordahl_dim = "Sunday"
tra_scrp_nordahl_heure = "Hours"
tra_scrp_nordahl_minute = "Minūtes"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "Virtual"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "Mainot laiku"
tra_scrp_nordahl_Cons = "konsole"
tra_scrp_nordahl_Groupmax = "Number Group"
tra_scrp_nordahl_script = "Script"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Pārsaukt grupu"
tra_scrp_nordahl_settime = "Virtual Conversion Time"
tra_scrp_nordahl_noevent = "Pašlaik nav notikumu, pārbaudiet plānošana"
tra_scrp_nordahl_titre = "Plānošana Server Notikumi"
tra_scrp_nordahl_only = "Tikai Rādīt In Event"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "Pašlaik"
tra_scrp_proch = "nākamajā stundā"
end
function langueeventplno(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "Planlegging"
tra_scrp_nordahl_e = "Slett"
tra_scrp_nordahl_lun = "Monday"
tra_scrp_nordahl_mar = "tirsdag"
tra_scrp_nordahl_mer = "onsdag"
tra_scrp_nordahl_jeu = "torsdag"
tra_scrp_nordahl_ven = "Fredag"
tra_scrp_nordahl_sam = "Lørdag"
tra_scrp_nordahl_dim = "Søndag"
tra_scrp_nordahl_heure = "timer"
tra_scrp_nordahl_minute = "Minutes"
tra_scrp_nordahl_heurere = "Ekte"
tra_scrp_nordahl_heurevi = "Virtual"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "Endre tid"
tra_scrp_nordahl_Cons = "i Console"
tra_scrp_nordahl_Groupmax = "Number Group"
tra_scrp_nordahl_script = "Script"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Endre gruppe"
tra_scrp_nordahl_settime = "Virtual Conversion Time"
tra_scrp_nordahl_noevent = "Det er for tiden ingen arrangementer, sjekk planlegging"
tra_scrp_nordahl_titre = "Planlegging for Server hendelser"
tra_scrp_nordahl_only = "Bare vis i Hendelses"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "tiden"
tra_scrp_proch = "I den neste timen"
end
function langueeventplro(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "planificare"
tra_scrp_nordahl_e = "Șterge"
tra_scrp_nordahl_lun = "luni"
tra_scrp_nordahl_mar = "Marți"
tra_scrp_nordahl_mer = "miercuri"
tra_scrp_nordahl_jeu = "Joi"
tra_scrp_nordahl_ven = "Vineri"
tra_scrp_nordahl_sam = "Sâmbătă"
tra_scrp_nordahl_dim = "duminică"
tra_scrp_nordahl_heure = "Ore"
tra_scrp_nordahl_minute = "minute"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "virtual"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "Schimbarea timpului"
tra_scrp_nordahl_Cons = "în consola"
tra_scrp_nordahl_Groupmax = "Grup număr"
tra_scrp_nordahl_script = "Script"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "grup Redenumire"
tra_scrp_nordahl_settime = "Timpul virtual de conversie"
tra_scrp_nordahl_noevent = "Nu există evenimente în prezent, verifica planificarea"
tra_scrp_nordahl_titre = "Planificarea pentru Server Evenimente"
tra_scrp_nordahl_only = "Arată numai în Eveniment"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "În prezent"
tra_scrp_proch = "În ceasul următor"
end
function langueeventplsv(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "planering"
tra_scrp_nordahl_e = "Delete"
tra_scrp_nordahl_lun = "måndag"
tra_scrp_nordahl_mar = "tisdag"
tra_scrp_nordahl_mer = "onsdag"
tra_scrp_nordahl_jeu = "torsdag"
tra_scrp_nordahl_ven = "Friday"
tra_scrp_nordahl_sam = "lördag"
tra_scrp_nordahl_dim = "Sunday"
tra_scrp_nordahl_heure = "timmar"
tra_scrp_nordahl_minute = "Minutes"
tra_scrp_nordahl_heurere = "Real"
tra_scrp_nordahl_heurevi = "Virtuell"
tra_scrp_nordahl_SH = "Time System"
tra_scrp_nordahl_Time = "Ändra tid"
tra_scrp_nordahl_Cons = "i konsolen"
tra_scrp_nordahl_Groupmax = "Number Group"
tra_scrp_nordahl_script = "kredit"
tra_scrp_nordahl_credit = "Made by Nordahl"
tra_scrp_nordahl_ng = "Byt namn på gruppen"
tra_scrp_nordahl_settime = "Virtual Conversion Time"
tra_scrp_nordahl_noevent = "Det finns inga händelser, kolla planering"
tra_scrp_nordahl_titre = "Planering för serverhändelser "
tra_scrp_nordahl_only = "Visa endast In Event"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "För närvarande"
tra_scrp_proch = "I nästa timme"
end
function langueeventpltr(z)Z_Defaut_Languages=z
if IsValid(LocalPlayer()) then
LocalPlayer():EmitSound("garrysmod/ui_return.wav",60,150)
end
tra_scrp_nordahl = "PLANLAMA"
tra_scrp_nordahl_e = "Sil"
tra_scrp_nordahl_lun = "Pazartesi"
tra_scrp_nordahl_mar = "Salı"
tra_scrp_nordahl_mer = "Çarşamba"
tra_scrp_nordahl_jeu = "Perşembe"
tra_scrp_nordahl_ven = "Cuma"
tra_scrp_nordahl_sam = "Cumartesi"
tra_scrp_nordahl_dim = "Pazar"
tra_scrp_nordahl_heure = "Saat"
tra_scrp_nordahl_minute = "Dakika"
tra_scrp_nordahl_heurere = "Gerçek"
tra_scrp_nordahl_heurevi = "Sanal"
tra_scrp_nordahl_SH = "Zaman Sistemi"
tra_scrp_nordahl_Time= "zaman değiştirme"
tra_scrp_nordahl_Cons = "konsolunda"
tra_scrp_nordahl_Groupmax = "Sayı Grubu"
tra_scrp_nordahl_script = "Kredi"
tra_scrp_nordahl_credit = "Nordahl tarafından yapılmıştır"
tra_scrp_nordahl_ng = "grubunu yeniden adlandırma"
tra_scrp_nordahl_settime = "Sanal Dönüşüm Zamanı"
tra_scrp_nordahl_noevent = "Şu anda olaylar, planlama kontrol var"
tra_scrp_nordahl_titre = "Sunucu olayları için Planlama"
tra_scrp_nordahl_only = "Sadece Durumunda göster"
tra_scrp_nordahl_only_inctxtmenu="Only show when the menucontext is open"
tra_scrp_actue = "Şu anda"
tra_scrp_proch = "Sonraki saat içinde"
end
 
if Z_Defaut_Languages==1 then
langueeventplfr(1)
elseif Z_Defaut_Languages==2 then
langueeventplen(2)
elseif Z_Defaut_Languages==3 then
langueeventples(3)
elseif Z_Defaut_Languages==4 then
langueeventpldu(4)
elseif Z_Defaut_Languages==5 then
langueeventplru(5)
elseif Z_Defaut_Languages==6 then
langueeventplel(6)
elseif Z_Defaut_Languages==7 then
langueeventplpt(7)
elseif Z_Defaut_Languages==8 then
langueeventplpl(8)
elseif Z_Defaut_Languages==9 then
langueeventplit(9)
elseif Z_Defaut_Languages==10 then
langueeventplbg(10)
elseif Z_Defaut_Languages==11 then
langueeventplcs(11)
elseif Z_Defaut_Languages==12 then
langueeventplet(12)
elseif Z_Defaut_Languages==13 then
langueeventplfi(13)
elseif Z_Defaut_Languages==14 then
langueeventplja(14)
elseif Z_Defaut_Languages==15 then
langueeventplko(15)
elseif Z_Defaut_Languages==16 then
langueeventpllv(16)
elseif Z_Defaut_Languages==17 then
langueeventplno(17)
elseif Z_Defaut_Languages==18 then
langueeventplro(18)
elseif Z_Defaut_Languages==19 then
langueeventplsv(19)
elseif Z_Defaut_Languages==20 then
langueeventpltr(20)
else
langueeventplen(2)
end

chat.AddText(Color(255,103,55),"")
chat.AddText(Color(255,103,55),"[",Color(255,255,255)," > ",Color(255,103,55),"] ",Color(255,103,55), " План ивентов")
chat.AddText(Color(255,103,55),"| ",Color(255,255,255),"В чате :",Color(255,103,55), " !event")
chat.AddText(Color(255,103,55),"| ",Color(255,255,255),"В консоли :",Color(255,103,55), " planning_event")
chat.AddText(Color(255,103,55),"")
chat.PlaySound()

if eanticonf2==nil then
eanticonf2=1
CONFIG.Jour="1"
local tra_scrp_nordahl_noevent=""
local files=file.Read("planningevent/prehud.txt","DATA")
if (!files) then
file.CreateDir("planningevent")
file.Write("planningevent/prehud.txt","1")
CONFIG.Hud=1
else
CONFIG.Hud=tonumber(file.Read("planningevent/prehud.txt","DATA"))
end
local files=file.Read("planningoption/hourformat.txt","DATA")
if (!files) then
file.CreateDir("planningoption")
file.Write("planningoption/hourformat.txt","0")
CONFIG.HourFormat="0"
else
CONFIG.HourFormat=file.Read("planningoption/hourformat.txt","DATA")
end
end

function tmevent(a,b,c)
CONFIG.Heure=tonumber(c[1])
if c[2]=="0" then
CONFIG.Jour="7"
else
CONFIG.Jour=c[2]
end
CONFIG.min=tonumber(c[3])
CONFIG.sec=tonumber(c[4])
if CONFIG.Enable_Notifsound_Event==1 then
if GetGlobalString("zeventplan1"..CONFIG.Jour..CONFIG.Heure)!="" then
Mommrk=CurTime()
surface.PlaySound("ambient/alarms/warningbell1.wav")
end
end

timer.Create("ebventplminute",1,0,function()
CONFIG.sec=CONFIG.sec+1
if CONFIG.sec>59 then
CONFIG.sec=0
CONFIG.min=CONFIG.min+1
end
if CONFIG.min>59 then
CONFIG.min=0
CONFIG.Heure=CONFIG.Heure+1
if CONFIG.Heure>23 then
CONFIG.Heure=0
end
if CONFIG.Enable_Notifsound_Event==1 then
if GetGlobalString("zeventplan1"..CONFIG.Jour..CONFIG.Heure)!="" then
Mommrk=CurTime()
surface.PlaySound("ambient/alarms/warningbell1.wav")
end
end
end
end)
end
concommand.Add("tmevent",tmevent)

local opstring=tostring
local zcolorbase=Color(0,255,0,200) local hookAdd=hook.Add

local function HUDPaint()
local compt=CurTime()-Mommrk

if compt<=duration then
local CONFIGJourHeure="zeventplan1"..CONFIG.Jour..CONFIG.Heure
local CONFIGJourHeureS="zeventplan1"..CONFIG.Jour..CONFIG.Heure+1
local y=30
local abc=700
local abc2=abc/2
if CONFIG.Hud==1 or (CONFIG.Hud==2 and GetGlobalString(CONFIGJourHeure)!="" or GetGlobalString(CONFIGJourHeureS)!="" ) or openmenu==true  then
draw.RoundedBox(4,ScrW()/2-(abc2+1),5+y,abc,14,Color(231/2,83/2,35/2,100))
draw.RoundedBox(4,ScrW()/2-(abc2),6+y,abc-2,12,Color(255,103,55,100))
draw.RoundedBox(2,ScrW()/2-(abc2),14+y,abc-2,33,Color(0,0,0,150))
draw.SimpleText("Planning Event","Trebuchet18",ScrW()/2,11+y,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))
draw.SimpleText(tra_scrp_actue..":","Trebuchet18",ScrW()/2-abc2/2,24+y,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))
draw.SimpleText(tra_scrp_proch..":","Trebuchet18",ScrW()/2+abc2/2,24+y,Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))
if GetGlobalString(CONFIGJourHeure)!="" then
draw.SimpleText(GetGlobalString(CONFIGJourHeure),"Trebuchet18",ScrW()/2-abc2/2,37+y,Color(0,255,0),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))
else
draw.SimpleText(tra_scrp_nordahl_noevent,"Trebuchet18",ScrW()/2-abc2/2,37+y,Color(255,103,55),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))
end
if GetGlobalString(CONFIGJourHeureS)!="" then
draw.SimpleText(GetGlobalString(CONFIGJourHeureS),"Trebuchet18",ScrW()/2+abc2/2,37+y,Color(200,200,200),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))
else
draw.SimpleText(tra_scrp_nordahl_noevent,"Trebuchet18",ScrW()/2+abc2/2,37+y,Color(255,103,55),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER,1,Color(0,0,0,100))
end
end
end
end
hook.Add("HUDPaint","nordahl_hud_planning",HUDPaint);

function planning_event(a,b,c)
LocalPlayer():EmitSound("garrysmod/ui_return.wav",45,100)
local Menu = vgui.Create("DFrame")
Menu:SetPos(ScrW()/2-505,150)
Menu:SetSize(990,720)
Menu:SetTitle("")
Menu:SetDraggable(false)
Menu:ShowCloseButton(false)
Menu:MakePopup()
local journom=""
Menu.Paint=function()
draw.RoundedBox(6,0,0,990,400,Color(231/2,83/2,35/2,255))
draw.RoundedBox(6,1,1,988,398,Color(0,0,0,255))
draw.RoundedBox(4,10,10,970,380,Color(255,103,55,100))
local jourhaut=17
local centvuit=128
local heureline=0+centvuit

for i=1, 7 do
if i==1 then
journom=tra_scrp_nordahl_lun
elseif i==2 then
journom=tra_scrp_nordahl_mar
elseif i==3 then
journom=tra_scrp_nordahl_mer
elseif i==4 then
journom=tra_scrp_nordahl_jeu
elseif i==5 then
journom=tra_scrp_nordahl_ven
elseif i==6 then
journom=tra_scrp_nordahl_sam
elseif i==7 then
journom=tra_scrp_nordahl_dim
end
if CONFIG.Jour==tostring(i) then 
local ezrzer=129+heureline
draw.RoundedBox(2,heureline-64,10,129,380,Color(0,255,0,255))
draw.RoundedBox(2,heureline-63,10,127,380,Color(204,245,210,255))
draw.SimpleText(journom,"Trebuchet18",heureline,jourhaut, Color(0,150,0), TEXT_ALIGN_CENTER, 0, 1, Color(0,0,0,255))
else
draw.SimpleText(journom,"Trebuchet18",heureline,jourhaut, Color(255,255,255), TEXT_ALIGN_CENTER, 0, 1, Color(0,0,0,255))
end
heureline=heureline+centvuit
end
local quinze=(15)*1
local colu=32
local heureline=0+quinze
local treize=38
for i=1, 24 do
local i=i-1
local heure0=""
if i<10 then heure0="0" end
if CONFIG.Heure==i then
if CONFIG.HourFormat=="0" and i>12 then
i=i-12
if i<10 then heure0="0" end
end
draw.RoundedBox(0,10,treize,970,15,Color(0,255,0,255))
draw.RoundedBox(0,10,treize+1,970,13,Color(204,245,210,255))
draw.SimpleText(heure0..i..":00","Trebuchet18",colu,treize-1, Color(0,150,0), TEXT_ALIGN_CENTER, 0, 1, Color(0,0,0,255))
else
if CONFIG.HourFormat=="0" and i>12 then
i=i-12
if i<10 then heure0="0" end
end
draw.SimpleText(heure0..i..":00","Trebuchet18",colu,treize-1, Color(255,255,255), TEXT_ALIGN_CENTER, 0, 1, Color(0,0,0,255))
end
treize=treize+(quinze-1)
end
end

local Menu2 = vgui.Create("DFrame",Menu)
Menu2:SetPos(ScrW()/2-505,108-6)
Menu2:SetSize(990,24)
Menu2:SetTitle("")
Menu2:SetDraggable(false)
Menu2:ShowCloseButton(false)
Menu2:MakePopup()
Menu2.Paint=function()
draw.RoundedBox(6,0,0,990,24,Color(231/2,83/2,35/2,255))
draw.RoundedBox(6,1,1,988,22,Color(0,0,0,255))
draw.RoundedBox(2,1,18,988,5,Color(255,103,55,100))
surface.SetDrawColor(255,255,255,255) 
surface.SetMaterial(Material("ngui/event.png"))surface.DrawTexturedRect(5,4,16,16)
draw.SimpleText("Server Event Manager", "Trebuchet18", 28, 12, Color(255,103,55), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

local Menu3 = vgui.Create("DFrame",Menu)
Menu3:SetPos(ScrW()/2-505,129)
Menu3:SetSize(990,18)
Menu3:SetTitle("")
Menu3:SetDraggable(false)
Menu3:ShowCloseButton(false)
Menu3:MakePopup()
local journom=""
if CONFIG.Jour=="1" then
journom=tra_scrp_nordahl_lun
elseif CONFIG.Jour=="2" then
journom=tra_scrp_nordahl_mar
elseif CONFIG.Jour=="3" then
journom=tra_scrp_nordahl_mer
elseif CONFIG.Jour=="4" then
journom=tra_scrp_nordahl_jeu
elseif CONFIG.Jour=="5" then
journom=tra_scrp_nordahl_ven
elseif CONFIG.Jour=="6" then
journom=tra_scrp_nordahl_sam
elseif CONFIG.Jour=="7" then
journom=tra_scrp_nordahl_dim
end
Menu3.Paint=function()
local hor0=""
local hor2=""
local mon0=""
local soc0=""
local it=CONFIG.Heure
if CONFIG.HourFormat=="0" and it>12 then
it=it-12
hor2="PM"
elseif CONFIG.HourFormat=="0" and it<=12 then
hor2="AM"
end


if it<10 then
hor0="0"
end
if CONFIG.sec<10 then
soc0="0"
end
if CONFIG.min<10 then
mon0="0"
end

if CONFIG.UTC_GMT>=0 then
plusmoin="+"
else
plusmoin=""
end
draw.RoundedBox(2,1,0,988,18,Color(0,129,32,150))
draw.SimpleText(" "..GetHostName()..", Дата: "..journom.." "..hor0..it..":"..mon0..CONFIG.min..":"..soc0..CONFIG.sec.." "..hor2.." "..", UTC/GMT:"..plusmoin..CONFIG.UTC_GMT..":00", "Trebuchet18", 495, 10, Color(255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end

local function planning_maj(a,b,c,d)
	timer.Create("miseajourplan"..a..b..c,1,0,function()
	if IsValid(d)then
	if d:GetValue()!=GetGlobalString("zeventplan"..CONFIG.Group..b..c) then
	d:SetText(GetGlobalString("zeventplan"..CONFIG.Group..b..c))
	end
	else
	timer.Remove("miseajourplan"..a..b..c)
	end
	end)
end
local casejedit=""
for f=1, 7 do
local quinze=15*1
local treize=38
	for i=1, 24 do
	local i=i-1
	local DTE = vgui.Create( "DTextEntry")
	local contenu=GetGlobalString("zeventplan"..CONFIG.Group..tostring(f)..i)
	DTE:SetParent(Menu)
	if eRight(LocalPlayer())==false then
	DTE:SetEditable(false);
	else
	DTE:SetEditable(true);
	end
	DTE:SetText(contenu)
	DTE:SetPos( -64+128*f,treize )
	DTE:SetSize( 129, quinze)
	DTE:SetMultiline(true)
	DTE:SetEnterAllowed( false )
	DTE.OnTextChanged = function(self)
	casejedit=DTE:GetValue()
	RunConsoleCommand("majeventplanning",opstring(DTE:GetValue()),tostring(f),opstring(i),CONFIG.Group)
	planning_maj(CONFIG.Group,tostring(f),i,DTE)
	end
	planning_maj(CONFIG.Group,tostring(f),i,DTE)
	treize=treize+(quinze-1)
	end
end
	
	
local button=vgui.Create("DButton",Menu2)
button:SetText("")
button:SetSize(16,16)
button:SetPos(Menu2:GetWide()-23-21-20,4)
button.Paint=function()end
local zmodcm=vgui.Create("DImage",Menu2)
zmodcm:SetImage("icon16/arrow_refresh.png")
zmodcm:SetSize(16,16)
zmodcm:SetPos(Menu2:GetWide()-23-21-20,4)
button.DoClick=function()
surface.PlaySound("ambient/machines/keyboard5_clicks.wav")
Menu:Close()
planning_event()
end

local button=vgui.Create("DButton",Menu2)button:SetText("")button:SetSize(16,16)
button.Paint=function()draw.RoundedBox(8,0,0,button:GetWide(),button:GetTall(),Color(0,0,0,0))
end
button:SetPos(Menu2:GetWide()-40,4)local zmodcm=vgui.Create("DImage",Menu2)zmodcm:SetImage("icon16/Wrench.png")zmodcm:SetSize(16,16)
zmodcm:SetPos(Menu2:GetWide()-40,4)button.DoClick=function()surface.PlaySound("ambient/machines/keyboard5_clicks.wav")
local z4=DermaMenu()

	local subMenu,optMenu=z4:AddSubMenu("Languages")
	optMenu:SetIcon("icon16/world.png")
	
	local flche=""
if Z_Defaut_Languages==1 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Français",function()file.Write("nordahlclient_option/language.txt","1")langueeventplfr(1)Menu:Close()
planning_event(ply)end):SetImage("ngui/la/fr.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==2 then flche=puce else flche="" end 
subMenu:AddOption(flche.."English",function()file.Write("nordahlclient_option/language.txt","2")langueeventplen(2)Menu:Close()
planning_event(ply)end):SetImage("ngui/la/en.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==3 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Español",function()file.Write("nordahlclient_option/language.txt","3")langueeventples(3)Menu:Close()
planning_event(ply)end):SetImage("ngui/la/es.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==4 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Deutsch",function()file.Write("nordahlclient_option/language.txt","4")langueeventpldu(4)Menu:Close()
planning_event(ply)end):SetImage("ngui/la/de.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==5 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Russian",function()file.Write("nordahlclient_option/language.txt","5")langueeventplru(5)Menu:Close()
planning_event(ply)end):SetImage("ngui/la/ru.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==6 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Greek",function()file.Write("nordahlclient_option/language.txt","6")langueeventplel(6)Menu:Close()planning_event(ply)end):SetImage("ngui/la/el.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==7 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Portuguese",function()file.Write("nordahlclient_option/language.txt","7")langueeventplpt(7)Menu:Close()planning_event(ply)end):SetImage("ngui/la/pt.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==8 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Polish",function()file.Write("nordahlclient_option/language.txt","8")langueeventplpl(8)Menu:Close()planning_event(ply)end):SetImage("ngui/la/pl.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==9 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Italian",function()file.Write("nordahlclient_option/language.txt","9")langueeventplit(9)Menu:Close()planning_event(ply)end):SetImage("ngui/la/it.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==10 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Bulgarian",function()file.Write("nordahlclient_option/language.txt","10")langueeventplbg(10)Menu:Close()planning_event(ply)end):SetImage("ngui/la/bg.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==11 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Czech",function()file.Write("nordahlclient_option/language.txt","11")langueeventplcs(11)Menu:Close()planning_event(ply)end):SetImage("ngui/la/cs.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==12 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Estonian",function()file.Write("nordahlclient_option/language.txt","12")langueeventplet(12)Menu:Close()planning_event(ply)end):SetImage("ngui/la/et.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==13 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Finnish",function()file.Write("nordahlclient_option/language.txt","13")langueeventplfi(13)Menu:Close()planning_event(ply)end):SetImage("ngui/la/fi.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==14 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Japanese",function()file.Write("nordahlclient_option/language.txt","14")langueeventplja(14)Menu:Close()planning_event(ply)end):SetImage("ngui/la/ja.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==15 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Korean",function()file.Write("nordahlclient_option/language.txt","15")langueeventplko(15)Menu:Close()planning_event(ply)end):SetImage("ngui/la/ko.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==16 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Latvian",function()file.Write("nordahlclient_option/language.txt","16")langueeventpllv(16)Menu:Close()planning_event(ply)end):SetImage("ngui/la/lv.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==17 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Norwegian",function()file.Write("nordahlclient_option/language.txt","17")langueeventplno(17)Menu:Close()planning_event(ply)end):SetImage("ngui/la/no.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==18 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Romanian",function()file.Write("nordahlclient_option/language.txt","18")langueeventplro(18)Menu:Close()planning_event(ply)end):SetImage("ngui/la/ro.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==19 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Swedish",function()file.Write("nordahlclient_option/language.txt","19")langueeventplsv(19)Menu:Close()planning_event(ply)end):SetImage("ngui/la/sv.png")
subMenu:AddSpacer()
if Z_Defaut_Languages==20 then flche=puce else flche="" end 
subMenu:AddOption(flche.."Turkish",function()file.Write("nordahlclient_option/language.txt","20")langueeventpltr(20)Menu:Close()planning_event(ply)end):SetImage("ngui/la/tr.png")

subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(231,83,35,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4:AddSpacer()
	local subMenu,optMenu=z4:AddSubMenu("Planning")
	optMenu:SetIcon("icon16/wrench.png")
	subMenu:AddOption("Cleanup",function()RunConsoleCommand("planning_server_reset") end):SetImage("icon16/cancel.png")
	subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(231,83,35,255))
	draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
	z4:AddSpacer()
	local subMenu,optMenu=z4:AddSubMenu("HUD")
	optMenu:SetIcon("icon16/wrench_orange.png")
local flche=""
if CONFIG.Hud==3 then flche=puce else flche="" end 
	subMenu:AddOption(flche.."Only Show when ContextMenu is Open",function()file.Write("planningevent/prehud.txt","3")CONFIG.Hud=3 end):SetImage("icon16/layers.png")
if CONFIG.Hud==2 then flche=puce else flche="" end 
	subMenu:AddOption(flche..tra_scrp_nordahl_only,function()file.Write("planningevent/prehud.txt","2")CONFIG.Hud=2 end):SetImage("icon16/layers.png")
if CONFIG.Hud==1 then flche=puce else flche="" end 
	subMenu:AddOption(flche.."Permanent",function()file.Write("planningevent/prehud.txt","1")CONFIG.Hud=1 end):SetImage("icon16/image.png")
if CONFIG.Hud==0 then flche=puce else flche="" end 
	subMenu:AddOption(flche.."OFF",function()file.Write("planningevent/prehud.txt","0")CONFIG.Hud=0 end):SetImage("icon16/image_delete.png")
subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(231,83,35,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4:AddSpacer()
	-- local subMenu,optMenu=z4:AddSubMenu("UTC/GMT: "..CONFIG.UTC_GMT..":00")
	-- optMenu:SetIcon("icon16/time.png")
	-- subMenu:AddOption("UTC/GMT-12",function()
	-- file.Write("planningoption/gmt.txt","5")CONFIG.UTC_GMT=5 end)
	-- subMenu:AddOption("UTC/GMT+1",function()
	-- file.Write("planningoption/gmt.txt","1")CONFIG.UTC_GMT=1 end)
	-- subMenu:AddOption("UTC/GMT+5",function()
	-- file.Write("planningoption/gmt.txt","5")CONFIG.UTC_GMT=5 end)

--z4:AddSpacer()
	local subMenu,optMenu=z4:AddSubMenu(tra_scrp_nordahl_SH)
	
	optMenu:SetIcon("icon16/time.png")
local flche=""
if CONFIG.HourFormat=="0" then flche=puce else flche="" end 
	subMenu:AddOption(flche.."12 "..tra_scrp_nordahl_heure.." AM/PM",function()
	file.Write("planningoption/hourformat.txt","0")CONFIG.HourFormat="0" end):SetImage("icon16/time.png")
if CONFIG.HourFormat=="1" then flche=puce else flche="" end 
	subMenu:AddOption(flche.."24 "..tra_scrp_nordahl_heure.."",function()
	file.Write("planningoption/hourformat.txt","1")CONFIG.HourFormat="1" end):SetImage("icon16/time.png")
	subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(231,83,35,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4:AddSpacer()
	local subMenu,optMenu=z4:AddSubMenu(tra_scrp_nordahl_script)
	optMenu:SetIcon("icon16/wand.png")
	subMenu:AddOption(tra_scrp_nordahl_credit,function()gui.OpenURL("https://scriptfodder.com/users/view/76561198033784269/scripts") end):SetImage("ngui/nordahl.png")
	subMenu:AddSpacer()
	subMenu:AddOption("You like my work?",function()gui.OpenURL("https://scriptfodder.com/scripts/view/"..scriptlink.."/reviews") end):SetImage("icon16/star.png")
	subMenu:AddSpacer()
	subMenu:AddOption("Workshop Content",function()gui.OpenURL("http://steamcommunity.com/sharedfiles/filedetails/?id=493897275") end)
	z4:AddSpacer()
subMenu.Paint=function()draw.RoundedBox(4,0,0,subMenu:GetWide(),subMenu:GetTall(),Color(231,83,35,255))
draw.RoundedBox(4,1,1,subMenu:GetWide()-2,subMenu:GetTall()-2,Color(255,255,255,255))end
z4:Open()
z4.Paint=function()draw.RoundedBox(4,0,0,z4:GetWide(),z4:GetTall(),Color(231,83,35,255))
draw.RoundedBox(4,1,1,z4:GetWide()-2,z4:GetTall()-2,Color(255,255,255,255))end
end
local button=vgui.Create("DButton",Menu2)button:SetText("")button:SetSize(16,16)
button.Paint=function()draw.RoundedBox(8,0,0,button:GetWide(),button:GetTall(),Color(0,0,0,0))
end
button:SetPos(Menu2:GetWide()-20,4)local zmodcm=vgui.Create("DImage",Menu2)zmodcm:SetImage("icon16/cross.png")zmodcm:SetSize(16,16)zmodcm:SetPos(Menu2:GetWide()-20,4)button.DoClick=function()surface.PlaySound("ambient/machines/keyboard5_clicks.wav")Menu:Close()
end
end
concommand.Add("planning_event",planning_event)

hook.Add( "OnContextMenuOpen","nordahl_eventplanningeditor",function(a,b,c)
if CONFIG.Hud==3 then
openmenu=true
end
end)
hook.Add( "OnContextMenuClose","nordahl_eventplanningeditor",function(a,b,c)
if CONFIG.Hud==3 then
openmenu=false
end
end)