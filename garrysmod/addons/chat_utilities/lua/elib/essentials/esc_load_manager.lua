

esclib.loader = esclib.loader or {}
esclib.loader.addons = esclib.loader.addons or {}


---------------------------
--# MATERIAL DOWNLOADER #--
---------------------------
--thanks to https://github.com/Be1zebub/Small-GLua-Things/blob/master/sh_material_downloader.lua

local file, Material, Fetch, find = file, Material, http.Fetch, string.find

if CLIENT then
	local DOWNLOAD_PATH = "esclib_download"
	local errorMat = Material("error")
	esclib.WebImageCache = esclib.WebImageCache or {}
	function esclib:DownloadMaterial(url, file_path, file_name, on_succ, on_err, retry_count)
		if not url then return end

		if esclib.WebImageCache[url] then 
			print("[esclib][MaterialDownloader] - Using chached material")
			if esclib.WebImageCache[url]:IsError() then
				on_err("Material isn't loaded properly. Maybe broken?")
				return false
			end
			on_succ(esclib.WebImageCache[url])
			return true
		end

		local folder = DOWNLOAD_PATH .. "/" .. file_path
		local path = folder .. "/" .. file_name
		esclib.file:MakeDirectoriesIfNotExists(folder)
		local data_path = "data/" .. path
		
		if file.Exists(path, "DATA") then
			print("[esclib][MaterialDownloader] - Material already exists. Using it")
			esclib.WebImageCache[url] = Material(data_path, "smooth")
			on_succ(esclib.WebImageCache[url])
		else
			Fetch(url, function(img)
				if img == nil or find(string.lower(img), "<!doctype html>", 1, true) then 
					print("[esclib][MaterialDownloader] - FAILED TO DOWNLOAD MATERIAL. URL: "..url)
					on_err("Bad url or not found image on it. Maybe link isn't direct?")
					return
				end

				file.Write(path, img)
				esclib.WebImageCache[url] = Material(data_path, "smooth")
				if esclib.WebImageCache[url]:IsError() then
					on_err("Downloaded material is broken.")
					print("[esclib][MaterialDownloader] Deleting bad downloaded file")
					file.Delete(path)
					return false
				end
				on_succ(esclib.WebImageCache[url])
			end, function(errMsg)
				if retry_count and retry_count > 0 then
					retry_count = retry_count - 1
					esclib:DownloadMaterial(url, path, on_succ, retry_count)
				else
					errMsg = errMsg or ""
					print("[esclib][MaterialDownloader] - BAD URL / PROBLEMS WITH INTERNET. URL: "..url.. " Response data: "..errMsg)
					on_err("Failed to download - "..errMsg)
				end
			end)
		end
	end

	function esclib:ClearDownloadCache(path)
		path = path or ""
		if path ~= "" then path = "/"..path end
		self.file:RemoveFolder(DOWNLOAD_PATH..path)
		table.Empty(esclib.WebImageCache)
	end

	concommand.Add("esclib_clear_cache", function()
		esclib:ClearDownloadCache()
	end)
end

--example
-- esclib:DownloadMaterial("https://i.imgur.com/Msmeqkq.png", "echat", "mat.png", function(mat)
--     local w, h = 128, 128
-- 	print(mat)
-- end)


local loader_meta = {}
function loader_meta:Print(msg)
	MsgC(Color(13, 255, 51), "• ")
	print(msg)
end

function loader_meta:Client(path)
	if (CLIENT) then include(self.dpath .. path) end
	if (SERVER) then
		AddCSLuaFile(self.dpath .. path)
		self:Print(self.dpath .. path)
	end
end

function loader_meta:ClientFolder(name,recurse)
	local files, folders = file.Find(self.dpath .. name .. "/*", "LUA")
	for k, fname in ipairs(files) do
		self:Client(name.."/"..fname)
	end
	if recurse then
		for _, fname in ipairs(folders) do
            self:ClientFolder(name .."/".. fname, recurse)
        end
    end
end

function loader_meta:Server(path)
	if (SERVER) then
		include(self.dpath .. path)
		self:Print(self.dpath .. path)
	end
end

function loader_meta:ServerFolder(name,recurse)
	local files, folders = file.Find(self.dpath .. name .. "/*", "LUA")
	for k, fname in ipairs(files) do
		self:Server(name.."/"..fname)
	end
	if recurse then
		for _, fname in ipairs(folders) do
            self:ServerFolder(name .."/".. fname, recurse)
        end
    end
end

function loader_meta:Shared(path)
	self:Client(path)
	self:Server(path)
end

function loader_meta:SharedFolder(name,recurse)
	local files, folders = file.Find(self.dpath .. name .. "/*", "LUA")
	for k, fname in ipairs(files) do
		self:Shared(name.."/"..fname)
	end
	if recurse then
		for _, fname in ipairs(folders) do
            self:SharedFolder(name .."/".. fname, recurse)
        end
    end
end

function loader_meta:Resource(fullpath)
	if (SERVER) then
		resource.AddFile(fullpath)
		self:Print("Resource added to loader: ( ".. fullpath.." )")
	end
end

function loader_meta:ResourceFolder(fullpath, recurse)
    local files, folders = file.Find(fullpath .."/*", "GAME")

    for _, fname in ipairs(files) do
        self:Resource(fullpath .."/".. fname)
    end

    if recurse then
        for _, fname in ipairs(folders) do
            self:ResourceFolder(fullpath .."/".. fname, recurse)
        end
    end
end

function loader_meta:Material(fullpath, name, download)
	if (SERVER) and (download) then
		--add to load
		resource.AddFile(fullpath)
		self:Print("Material added to loader: ( ".. fullpath.." )")
	end

	--yes on sv too
	local mat = Material(fullpath,"smooth")
	if name then
		self.Materials[name] = mat
	else
		table.insert(self.Materials, mat)
	end
	return mat
end

function loader_meta:GetMaterials()
	return self.Materials or {}
end

function loader_meta:MaterialFolder(fullpath, recurse, download)
    local files, folders = file.Find(fullpath .."/*", "GAME")

    for _, fname in ipairs(files) do
        self:Material(fullpath .."/".. fname, fname, download)
    end

    if recurse then
        for _, fname in ipairs(folders) do
            self:MaterialFolder(fullpath .."/".. fname, recurse, download)
        end
    end
end

function loader_meta:MaterialUrl(name, url)
	if (CLIENT) then
		self:Print("Downloading material: ( ".. self.dpath .. name.." ) Retries: 2")
		esclib:DownloadMaterial(url, self.dpath, name, function(mat)

			if IsValid(mat) then
				self.Materials[name] = mat
				self:Print("Downloading succesuful")
			else
				self:Print("Downloading failed...")
			end
		end) --after 2 retries stop
	end
end




function esclib.loader:New(uid,path,callback)
	if not uid then return end
	if not path then return end
	if not callback then
		callback = path
		path = ""
	end
	if not isfunction(callback) then return end

	-- if already exists:
	if self.addons[uid] then 
		self.addons[uid]["Materials"] = {}
		self.addons[uid]["dpath"] = path
		self.addons[uid]["Load"] = function(add)
			add.finished = false
			callback(add)
			add.finished = true
		end

		table.Merge(self.addons[uid], loader_meta)

		self.addons[uid]:Load()
		return
	end

	--else
	self.addons[uid] = {}
	self.addons[uid]["Materials"] = {}
	self.addons[uid]["dpath"] = path
	self.addons[uid]["Load"] = function(add)
		add.finished = false
		callback(add)
		add.finished = true
	end

	table.Merge(self.addons[uid], loader_meta)
	self.addons[uid]:Load()
	-- setmetatable(self.addons[uid], loader_meta)

end

function esclib.loader:LoadAllAddons()
	for uid,addon in pairs(self.addons) do
		addon:Load()
	end
end

function esclib.loader:IsLoaded(addon_name)
	if esclib.loader.addons[addon_name] then
		return esclib.loader.addons[addon_name].finished
	end
end

-- esclib.loader:New("ehud","ehud/",function(load)
-- 	-- PrintTable(loader)
-- 	load:Client("config/ehud_config.lua")
-- end)

-- esclib.loader:LoadAllAddons()


