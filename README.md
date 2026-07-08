# StarsSaveSystem
Stars Save System is a easy to use sytem to store data for your games using Roblox's DataStoreService, Memory Stores and and Luau in-memory.

![Version](https://img.shields.io/github/v/release/StarTheProot/StarsSaveSystem)

## Installation

> [!IMPORTANT]
> Due to Roblox restrictions, this module script is not available on the Creator Store. You must install it manually.

1. Click on the newest release and download the `StarsSaveSystem.luau`
2. Drag and drop the file into Roblox Studio **OR** Press file > Import Roblox Model then in your file manager, press on `All Roblox Model Files (*.rbxm *.rbxmx)` and change it to `Script Files (*.luau *.lua *.txt)`, now find the `StarsSaveSystem.luau` file.
3. Place the script in ServerScriptService if you are not planning on using Luau in-memory (`TemporarySave()`) with the client, Otherwise place in ReplicatedStorage

> [!WARNING]
> If storing sensitive information in Luau in-memory (`TemporarySave()`), keep it in ServerScriptService (or another server-only location), 
	The client cannot access it directly.

## Features
- Save permanent server data
- Save permanent player data
- Fast temporary server-wide storage using MemoryStore
- Local temporary storage using Luau tables
- Automatic error handling
- DataStore caching control
- Simple API

## Basic Usage
### Saving Server Data
Server data is shared between all players and persists between sessions.

```lua
local SaveSystem = require(game.ServerScriptService.StarsSaveSystem)

SaveSystem.SaveServerData(
    "TrainsSpawned",
    5
)

```

### Getting Server Data

```lua
local SaveSystem = require(game.ServerScriptService.StarsSaveSystem)

local success, data = SaveSystem.GetServerData("TrainsSpawned")

if success then
    print(data)
end

```

### Deleting Server Data
```lua
SaveSystem.DeleteServerData("TotalMoney")
```

---

### Saving Player Data
Player data is stored using the player's UserId.
> [!IMPORTANT]
> It is always recommend to always save data relating to individual players with `SavePlayerData()` to aid in deletion in case of a GDPR deletion request.
```lua
  SaveSystem.SavePlayerData(
    "123456789",
    {
        Coins = 100,
        Level = 5
    }
)
```

### Loading Player Data
```lua
local success, data = SaveSystem.GetPlayerData("123456789")

if success then
    print(data.Coins)
end
```

### Deleting Player Data
```lua
SaveSystem.DeletePlayerData("123456789")
```
---

## ServerQuickSave (MemoryStore)
ServerQuickSave uses Roblox MemoryStore.
> [!WARNING]
> ServerQuickSave (Named Memory stores) are a high throughput and low latency data service that
	provides fast memory data storage accessible from all servers in a live session. Memory
	Stores are useful for frequent and/or ephemeral data data that change rapidly and don't
	need to be durable.
	All memory stores must have an expiry, once the expiry passed, they delete.
  For data that needs to persist across sessions, use SaveServerData() or SavePlayerData()
  It is recommended for you to read more at: https://create.roblox.com/docs/cloud-services/memory-stores

To use ServerQuickSave, you need to enable it first:
```lua
SaveSystem.EnableServerQuickSave()
```

### Saving Quick Data
```lua
SaveSystem.ServerQuickSave(
    "CurrentEvent",
    {
        Active = true
    },
    3600
)
```
The expiration time is in seconds. Maximum expiration is 3888000 seconds (45 days), trying to input anything higher will cause the expiration to set to 3888000 seconds.

### Getting Quick Data
```lua
local success, data = SaveSystem.ServerQuickSaveGet("CurrentEvent")

if success then
    print(data.Active)
end
```

### Removing Quick Data
```lua
SaveSystem.ServerQuickSaveDelete("CurrentEvent")
```
---

## TemporarySave (Luau Memory)
TemporarySave stores data only in the current server/client memory.
> [!WARNING]
> Temporary Save works on both the client, and the server. Saving on the server will not reflect to the client, and vice versa.
  Temporary Save does not persist across sessions, instead use SaveServerData() or SavePlayerData().
  Temporary Save does not sync across servers, setting data on this server will not change data on other servers.

### Saving Temporary Data
```lua
SaveSystem.TemporarySave(
    "RoundState",
    "Playing"
)
```

### Getting Temporary Data
```lua
local state = SaveSystem.TemporarySaveGet("RoundState")

print(state)
)
```

### Deleting Temporary Data
```lua
SaveSystem.TemporarySaveDelete("RoundState")
```

---

## DataStore Caching
> [!NOTE]
> Caching is enabled by default.

> [!WARNING]
> Disabling caching is only useful if you have multiple servers writing to a key with high frequency and need to get the latest value from servers. 
	Disabling caching will cause you to consume more of your datastore limits and quotas. 
	Learn more at: https://create.roblox.com/docs/cloud-services/data-stores/versioning-listing-and-caching#disable-caching

### Disable Caching

```lua
SaveSystem.DisableCaching()
```

### Enable Caching

```lua
SaveSystem.EnableCaching()
```

---

## Error Handling
All DataStore and MemoryStore functions return success status.
Example:

```lua
local success, errorMessage = SaveSystem.SaveServerData(
    "Test",
    true
)

if not success then
    warn(errorMessage)
end
```

## Conclusion
If you need assistance or need to report a bug, create an [issue](https://github.com/StarTheProot/StarsSaveSystem/issues)
