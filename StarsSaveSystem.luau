--[[
 ____  _                   ____                  
/ ___|| |_ __ _ _ __ ___  / ___|  __ ___   _____ 
\___ \| __/ _` | '__/ __| \___ \ / _` \ \ / / _ \
 ___) | || (_| | |  \__ \  ___) | (_| |\ V /  __/
|____/ \__\__,_|_|  |___/ |____/ \__,_| \_/ \___|
/ ___| _   _ ___| |_ ___ _ __ ___                
\___ \| | | / __| __/ _ \ '_ ` _ \               
 ___) | |_| \__ \ ||  __/ | | | | |              
|____/ \__, |___/\__\___|_| |_| |_|              
       |___/                                 				


ℹ️ - Stars Save System is a easy to use sytem to store data for your games using Roblox's DataStoreService, Memory Stores and and Luau in-memory.

⚠️ - Do not edit any parts of this script, or you will be going against the copyright policy.

🗀 - Place this script in ServerScriptService if you are not planning on using Luau in-memory with the client, Otherwise 

⚠️ - If storing sensitive information in Luau in-memory, keep it in ServerScriptService (or another server-only location), 
	The client cannot access it directly.

⇄ - For more information on how to use this module, go to https://github.com/StarTheProot/StarsSaveSystem/




Copyright © 2026 Roblox: Cloud_Codes1, GitHub: StarTheProot

All rights reserved.

Permission is granted to use this software free of charge.

You may:
- Use this software for personal and commercial purposes.

You may not:
- Modify this software.
- Copy or redistribute this software.
- Sell or sublicense this software.
- Create derivative works without written permission.

Any use of this software must retain this copyright notice.

For permission to modify or redistribute this software, contact the copyright holder.

]]






-- Services

local DataStoreService:DataStoreService = game:GetService("DataStoreService")
local MemoryStoreService:MemoryStoreService = game:GetService("MemoryStoreService")

-- Variables

local header = "// Stars Save System // "
local gitHubLink = "https://github.com/StarTheProot/StarsSaveSystem/"

-- Data Store Variables

local serverDataStore:DataStore = DataStoreService:GetDataStore("ServerStores")
local playerDataStore:DataStore = DataStoreService:GetDataStore("PlayerStores")

-- MemoryStore Variables

local gameMemoryStore:MemoryStoreHashMap = MemoryStoreService:GetHashMap("gameMemoryStore")

-- Package Link Checker

if script:FindFirstChild("PackageLink") then
	if script.PackageLink.AutoUpdate == false then
		warn(header.."Package link AutoUpdate is disabled, enable to get automatic updates")
	end
else
	warn(header.."Package link missing! Please reinstall StarsSaveSystem to get updates and support")
end

local version = script.PackageLink.VersionNumber

local caching = true

local memoryStoreEnabled = false

local warningShowedForInMemory = false

-- Debug Prints

print(header)
print("Version: ".. version)
print("Need help? "..gitHubLink)
print(header.."Ready")

-- Caching Management
local dataStoreGetOptions = Instance.new("DataStoreGetOptions")
dataStoreGetOptions.UseCache = caching

-- Module

local SaveSys = {}

function SaveSys.DisableCaching()
	warn(header..[[
	Disabling caching is only useful if you have multiple servers writing to a key with high frequency and need to get the latest value from servers. 
	Disabling caching will cause you to consume more of your datastore limits and quotas. 
	Learn more at: https://create.roblox.com/docs/cloud-services/data-stores/versioning-listing-and-caching#disable-caching
	
	Caching has been disabled, you can re-enable using EnableCaching(). Caching is enabled by default]])
	
	caching = false
	dataStoreGetOptions.UseCache = caching
end

function SaveSys.EnableCaching()
	if caching then
		warn(header.."Caching is already enabled, use DisableCaching() to disable. Read more here: https://create.roblox.com/docs/cloud-services/data-stores/versioning-listing-and-caching#disable-caching")
	else
		print(header.."Caching has been enabled. Learn more here: https://create.roblox.com/docs/cloud-services/data-stores/versioning-listing-and-caching")
	end
	caching = true
	dataStoreGetOptions.UseCache = caching
end

function SaveSys.EnableServerQuickSave()
	warn(header..[[
	ServerQuickSave (Named Memory stores) are a high throughput and low latency data service that
	provides fast memory data storage accessible from all servers in a live session. Memory
	Stores are useful for frequent and/or ephemeral data data that change rapidly and don't
	need to be durable.
	
	All memory stores must have an expiry, once the expiry passed, they delete.
	
	For data that needs to persist across sessions, use SaveServerData() or SavePlayerData()
	
	It is recommended for you to read more at: https://create.roblox.com/docs/cloud-services/memory-stores
	
	ServerQuickSave() is now activated.
	
	]])
	
	memoryStoreEnabled = true
	
end

-- Server Data

function SaveSys.SaveServerData(dataName:string,data:string|number|boolean|{[any]: any}): (boolean, string?)
	print(header.."SaverServerData Request - DataName: "..dataName)
	local success, errorMsg = pcall(function()
		serverDataStore:SetAsync(dataName,data)
	end)
	if success then
		print(header.."SaverServerData Request - Completed Successfully")
		return true
	else	
		warn(header.."SaverServerData Request - Failed | Error: "..errorMsg)
		return false,errorMsg
	end
end

function SaveSys.GetServerData(dataName:string): (boolean,any|string)
	print(header.."GetServerData Request - DataName: "..dataName)
	local data
	local success, errorMsg = pcall(function()
		data = serverDataStore:GetAsync(dataName,dataStoreGetOptions)
	end)
	if success then
		print(header.."GetServerData Request - Completed Successfully")
		return true, data
	else	
		warn(header.."GetServerData Request - Failed | Error: "..errorMsg)
		return false, errorMsg
	end
end

function SaveSys.DeleteServerData(dataName:string): (boolean)
	print(header.."DeleteServerData Request - dataName: "..dataName)
	local success = pcall(function()
		serverDataStore:RemoveAsync(dataName)
	end)
	if success then
		print(header.."DeleteServerData Request - Completed Successfully")
		return true
	else	
		warn(header.."DeleteServerData Request - Failed")
		return false
	end
end

-- Player Data


function SaveSys.SavePlayerData(userID:string,data:{[any]: any}): (boolean, string?)
	print(header.."SavePlayerData Request - UserID: "..userID)
	local success, errorMsg = pcall(function()
		playerDataStore:SetAsync(userID,data,{userID})
	end)
	if success then
		print(header.."SavePlayerData Request - Completed Successfully")
		return true
	else	
		warn(header.."SavePlayerData Request - Failed | Error: "..errorMsg)
		return false,errorMsg
	end
end

function SaveSys.GetPlayerData(userID:string): (boolean,{[any]: any}|string)
	print(header.."GetPlayerData Request - UserID: "..userID)
	local data
	local success, errorMsg = pcall(function()
		data = playerDataStore:GetAsync(userID,dataStoreGetOptions)
	end)
	if success then
		print(header.."GetPlayerData Request - Completed Successfully")
		return true, data
	else	
		warn(header.."GetPlayerData Request - Failed | Error: "..errorMsg)
		return false, errorMsg
	end
end

function SaveSys.DeletePlayerData(userID:string): (boolean)
	print(header.."DeletePlayerData Request - UserID: "..userID)
	local success = pcall(function()
		playerDataStore:RemoveAsync(userID)
	end)
	if success then
		print(header.."DeletePlayerData Request - Completed Successfully")
		return true
	else	
		warn(header.."DeletePlayerData Request - Failed")
		return false
	end
end

-- Quick Save Data


function SaveSys.ServerQuickSave(dataName:string,data:any,expirationSeconds:number): (boolean, string?)
	if not memoryStoreEnabled then
		warn(header.."ServerQuickSave() must be enabled by EnableServerQuickSave() before using.")
		return false, "ServerQuickSave() must be enabled by EnableServerQuickSave() before using."
	end
	
	print(header.."ServerQuickSave Request - DataName: "..dataName)
	
	if expirationSeconds > 3888000 then
		expirationSeconds = 3888000
		warn("ServerQuickSave - Expiration cannot exceed 3888000. Expiration has been set to 3888000 (45 Days)")
	end
	
	local success, errorMsg = pcall(function()
		gameMemoryStore:SetAsync(dataName,data,expirationSeconds)
	end)
	
	if success then
		print(header.."ServerQuickSave Request - Completed Successfully")
		return true
	else	
		warn(header.."ServerQuickSave Request - Failed | Error: "..errorMsg)
		return false, errorMsg
	end
	
end

function SaveSys.ServerQuickSaveGet(dataName:string): (boolean,any|string)
	if not memoryStoreEnabled then
		warn(header.."ServerQuickSaveGet() must be enabled by EnableServerQuickSave() before using.")
		return false, "ServerQuickSaveGet() must be enabled by EnableServerQuickSave() before using."
	end

	print(header.."ServerQuickSaveGet Request - DataName: "..dataName)

	local data
	
	local success, errorMsg = pcall(function()
		data = gameMemoryStore:GetAsync(dataName)
	end)

	if success then
		print(header.."ServerQuickSaveGet Request - Completed Successfully")
		return true, data
	else	
		warn(header.."ServerQuickSaveGet Request - Failed | Error: "..errorMsg)
		return false, errorMsg
	end

end

function SaveSys.ServerQuickSaveDelete(dataName:string): (boolean)
	if not memoryStoreEnabled then
		warn(header.."ServerQuickSaveDelete() must be enabled by EnableServerQuickSave() before using.")
		return false, "ServerQuickSaveDelete() must be enabled by EnableServerQuickSave() before using."
	end

	print(header.."ServerQuickSaveDelete Request - DataName: "..dataName)


	local success, errorMsg = pcall(function()
		gameMemoryStore:RemoveAsync(dataName)
	end)

	if success then
		print(header.."ServerQuickSaveDelete Request - Completed Successfully")
		return true
	else	
		warn(header.."ServerQuickSaveDelete Request - Failed")
		return false
	end

end

-- Temporary Save Data

local TempSaveData = {}




function SaveSys.TemporarySave(dataName:string,data:any)
	if not warningShowedForInMemory then
		warn(header..[[
		Temporary Save works on both the client, and the server. Saving on the server will not reflect to the client, and vice versa.
		Temporary Save does not persist across sessions, instead use SaveServerData() or SavePlayerData().
		Temporary Save does not sync across servers, setting data on this server will not change data on other servers.
		
		This warning will not be shown again
		]])
		warningShowedForInMemory = true	
	end
	print(header.."TemporarySave - Saved: DataName: "..dataName)
	TempSaveData[tostring(dataName)] = data
end

function SaveSys.TemporarySaveGet(dataName:string): (any)
	if not warningShowedForInMemory then
		warn(header..[[
		Temporary Save works on both the client, and the server. Saving on the server will not reflect to the client, and vice versa.
		Temporary Save does not persist across sessions, instead use SaveServerData() or SavePlayerData().
		Temporary Save does not sync across servers, setting data on this server will not change data on other servers.
		
		This warning will not be shown again
		]])
		warningShowedForInMemory = true	
	end
	print(header.."TemporarySaveGet - Requested: DataName: "..dataName)
	return TempSaveData[dataName]
end

function SaveSys.TemporarySaveDelete(dataName:string)
	if not warningShowedForInMemory then
		warn(header..[[
		Temporary Save works on both the client, and the server. Saving on the server will not reflect to the client, and vice versa.
		Temporary Save does not persist across sessions, instead use SaveServerData() or SavePlayerData().
		Temporary Save does not sync across servers, setting data on this server will not change data on other servers.
		
		This warning will not be shown again
		]])
		warningShowedForInMemory = true	
	end
	print(header.."TemporarySaveDelete - Requested: DataName: "..dataName)
	TempSaveData[dataName] = nil
end

return SaveSys
