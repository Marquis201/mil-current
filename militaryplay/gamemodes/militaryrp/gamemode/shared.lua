local FindMetaTable = FindMetaTable

GM = GM or GAMEMODE
GAMEMODE = GM or GAMEMODE

GM.Sandbox = BaseClass

mp = mp or {}
mp.config = mp.config or {}
mp.util = mp.util or {}
mp.commands = mp.commands or {}

--	Gamemode
GM.Name = 'MilitaryRP'
GM.Author = 'Kedr Greg Ozor Fernandez'
GM.Email = 'mpteam@gmail.com'
GM.Website = 'sss'

--	Metatables.
pMeta = FindMetaTable("Player")
eMeta = FindMetaTable("Entity")
vMeta = FindMetaTable("Vector")
paMeta = FindMetaTable("Panel")

PLAYER, ENTITY, VECTOR = pMeta, eMeta, vMeta
_player, _team, _file, _table, _sound = player, team, file, table, sound
