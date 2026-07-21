--!strict
-- FRAMEWORK BUILDER with integrated documentation
-- Paste the whole thing into Roblox Studio's Command Bar (View > Command Bar) and run 


local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")

local function make(className: string, name: string, parent: Instance): Instance
	local inst = Instance.new(className)
	inst.Name = name
	inst.Parent = parent
	return inst
end

local function setSource(scriptInstance: Instance, source: string)
	(scriptInstance :: any).Source = source
end

-- ============================================================
-- ReplicatedStorage/Framework
-- ============================================================

local RS_Framework = make("Folder", "Framework", ReplicatedStorage)

local RS_FrameworkReadme = make("ModuleScript", "_README", RS_Framework)
setSource(RS_FrameworkReadme, [==[
--!strict
--[[
	FRAMEWORK — READ ME FIRST

	WHAT IS THIS?
	A toolbox for making Roblox games. It is NOT a Knit/Aero-style framework that
	forces you to organize your whole game a specific way. Nothing here is mandatory:
	use only what's useful to you, ignore the rest.

	GOLDEN RULE
	No piece depends on you using the others.
	  - Only want Signal?              Copy ReplicatedStorage/Framework/Shared/Signal and done.
	  - Only want Net (RemoteEvents)?  Copy Shared/Net and done.
	  - Only want Services/Controllers but not ECS?  Fine, ignore the ECS folder.
	  - Only want ECS but not Services?               Fine, ignore Services/Controllers.
	See "_PORTABLE_MODULES" (in this same folder) to know exactly what can be
	copied in isolation.

	QUICK MAP (where everything is)

	ReplicatedStorage/Framework
	  Types                -> shared types (Service/Controller), editor-only.
	  Shared/Signal         -> internal events (pure Lua, no RemoteEvents).
	  Shared/Net            -> client-server communication (RemoteEvents/Functions).
	  Shared/Boot/ModuleRegistry -> the generic engine that loads Services and Controllers.
	  Shared/ECS            -> Entity-Component system (World, System, TagBridge).

	ServerScriptService/Framework
	  Boot/Loader           -> starts your Services.
	  Services/             -> YOUR SERVICES GO HERE (one per ModuleScript).
	  ECS/                  -> server World + server Systems bootstrap.
	  ECS/Systems/          -> YOUR SERVER SYSTEMS GO HERE.

	StarterPlayerScripts/Framework
	  Boot/Loader           -> starts your Controllers.
	  Controllers/          -> YOUR CONTROLLERS GO HERE (one per ModuleScript).
	  ECS/                  -> client World + client Systems bootstrap.
	  ECS/Systems/          -> YOUR CLIENT SYSTEMS GO HERE.

	HOW EVERYTHING LOADS
	Each Bootstrap (a regular Script/LocalScript) calls its Loader. The Loader
	automatically looks for the "Services"/"Controllers"/"Systems" folder next
	to it and does require() on every ModuleScript found there
	(ignoring ones that start with "_", which are documentation).
	There's no hidden magic: if you want to see exactly what happens, open
	Shared/Boot/ModuleRegistry or ECS/SystemRegistry, they're both under 100 lines.

	THE UNDERSCORE "_" CONVENTION
	Any ModuleScript starting with "_" (like this very file) is
	documentation or intentionally disabled. The framework never requires
	or runs it. You can also use it to "turn off" a Service/Controller/System
	without deleting it: just put a "_" in front of its name.

	IF YOU ONLY HAVE 5 MINUTES
	1. Look at the "Services", "Controllers", and "ECS/Systems" folders: that's
	   where you'll be writing code every day.
	2. Every important folder has its own "_README" explaining when to use it
	   and when not to. Open them if you have doubts about a specific folder.
	3. Read "_HOW_TO_SCALE" once the project starts growing.

	This file does nothing, it's just text. Do not require() it from your code.
]]

return nil
]==])

local RS_FrameworkHowToScale = make("ModuleScript", "_HOW_TO_SCALE", RS_Framework)
setSource(RS_FrameworkHowToScale, [==[
--!strict
--[[
	HOW TO SCALE WITH THIS FRAMEWORK

	This isn't theory, these are practical recommendations depending on your situation.
	Remember: none of this is mandatory, it's all just suggestions.

	IF YOUR GAME HAS FEW SYSTEMS (a prototype, a jam, a small game)
	  - Don't use ECS. Use regular Services and Controllers, or not even that: a
	    couple of loose Scripts is also valid if the project is small.
	  - Don't bother with Components/World, it's more code than you need.

	IF YOUR GAME HAS HUNDREDS OF SYSTEMS (many NPCs, objects, mechanics)
	  - That's where ECS starts paying off: World + Systems saves you from
	    having one giant Service with "if enemy then ... elseif npc then ...".
	  - Use TagBridge + CollectionService so you don't have to manually register
	    each instance (see "_TAGS_AND_COLLECTIONSERVICE" inside Shared/ECS).

	IF YOU WORK ALONE
	  - Prioritize what you'll understand quickly in 6 months, not what's
	    "most correct." Fewer folders, fewer layers. A couple of big Services is fine.

	IF YOU HAVE A TEAM
	  - Split by Services/Controllers/Systems: each person can touch their
	    own ModuleScript without stepping on anyone else's work.
	  - Use clear file names (the ModuleScript's name IS the system's name,
	    no need to dig through code to know what's what).

	IF YOU HIRE A SCRIPTER OR SOMEONE NEW JOINS
	  - Send them straight to this "_README" in the Framework folder.
	  - Everything explains itself just by opening the Explorer, no need for
	    external documentation or a 40-page Notion doc.

	IF YOU USE COLLECTIONSERVICE (tags in Studio)
	  - See "_TAGS_AND_COLLECTIONSERVICE" in Shared/ECS. Summary: tags + TagBridge
	    for things that repeat a lot (enemies, doors, pickups). For unique
	    things (a final boss, a menu) it's not needed, use a regular Service.

	GENERAL RULE FOR DECIDING WHETHER TO ADD SOMETHING
	Ask yourself: "does this get my game finished sooner?" If the answer is no,
	don't add it yet. You can grow little by little, the framework doesn't stop you.
]]

return nil
]==])

local RS_FrameworkPortableModules = make("ModuleScript", "_PORTABLE_MODULES", RS_Framework)
setSource(RS_FrameworkPortableModules, [==[
--!strict
--[[
	PORTABLE MODULES — what you can take to another project

	Copy only what you need. This list tells you what depends on what.

	✅ Shared/Signal
	   100% independent. Copy and paste it into any Roblox project.

	✅ Shared/Net
	   100% independent (only depends on built-in Roblox services:
	   ReplicatedStorage, RunService, Players). Copy it as-is.

	✅ Shared/Boot/ModuleRegistry
	   100% independent. It's a generic ModuleScript loader, it doesn't know
	   anything about Services or this particular framework.

	⚠ Shared/ECS (Component, System, World, SystemRegistry, TagBridge)
	   Portable as a set, but these 5 files depend on each other
	   (World needs Component, SystemRegistry needs System and World,
	   TagBridge needs World). Copy ALL of them together or none.
	   They don't depend on Services/Controllers, so you can use ECS without
	   touching the rest of the framework.

	⚠ Types
	   Portable, but doesn't do anything on its own: it's just type annotations
	   meant for Services/Controllers. If you don't use those folders, you don't need it.

	❌ Boot/Loader (server and client), Bootstrap, SystemBootstrap
	   These ARE tied to this specific framework's folder structure
	   (they look for a "Services"/"Controllers"/"Systems" folder right
	   next to them). You can copy them, but you'll have to recreate that
	   same folder structure in the destination project.

	In short: if you only want a couple of loose utilities, stick with
	Signal, Net, and ModuleRegistry. If you want the full Services/Controllers
	system or the ECS, copy them as a complete block.
]]

return nil
]==])

local RS_FrameworkIndex = make("ModuleScript", "_INDEX", RS_Framework)
setSource(RS_FrameworkIndex, [==[
--!strict
--[[
	INDEX — START HERE

	This is a map, not an explanation. Each question below tells you
	which README to check for details. Nothing is repeated here, it just
	points you to the right door.

	WHERE DO I START?
	  -> Framework/_README (right here). Has the full map of
	     folders and how everything loads.

	WHERE DO I CREATE A SERVICE?
	  -> ServerScriptService/Framework/Services (its _README is right in there).

	WHERE DO I CREATE A CONTROLLER?
	  -> StarterPlayerScripts/Framework/Controllers (its _README is right in there).

	I WANT TO USE ECS?
	  -> Shared/ECS/_README. If you're going to use CollectionService tags,
	     also see Shared/ECS/_TAGS_AND_COLLECTIONSERVICE.

	I WANT TO USE SIGNAL?
	  -> Shared/Signal (the comment is at the top of the module itself).

	I WANT TO COMMUNICATE CLIENT AND SERVER?
	  -> Shared/Net (the comment is at the top of the module itself).

	WHICH MODULES ARE OPTIONAL?
	  -> All of them, no exceptions. See Framework/_README, "GOLDEN RULE" section.

	WHICH MODULES ARE PORTABLE?
	  -> Framework/_PORTABLE_MODULES.

	REMEMBER
	None of this is mandatory. Use only what's useful to you, ignore the rest.
	The framework adapts to you, not the other way around.
]]

return nil
]==])

local TypesModule = make("ModuleScript", "Types", RS_Framework)
setSource(TypesModule, [==[
--!strict
--[[
	TYPES
	What it is: the "Service" and "Controller" types used by this framework's modules.
	Why it exists: to get editor autocomplete and warnings (Luau strict).
	When to use it: if you want to type your own Services/Controllers, do
	               `local MyService: Service = { Name = "MyService" }` (optional).
	When NOT to use it: it doesn't validate anything at runtime. If you don't
	                  care about typing anything, ignore this file entirely, it breaks nothing.
]]

export type Service = {
	Name: string,
	Init: ((self: Service) -> ())?,
	Start: ((self: Service) -> ())?,
	[any]: any,
}

export type Controller = {
	Name: string,
	Init: ((self: Controller) -> ())?,
	Start: ((self: Controller) -> ())?,
	[any]: any,
}

return {}
]==])

local Shared = make("Folder", "Shared", RS_Framework)

local SharedReadme = make("ModuleScript", "_README", Shared)
setSource(SharedReadme, [==[
--!strict
--[[
	SHARED — folder explained

	WHAT IT'S FOR
	Everything that lives here can be used by both server and client
	(because it's in ReplicatedStorage). This is where generic tools go,
	not your game's specific logic.

	WHAT'S INSIDE
	  Signal   -> internal Lua events (doesn't cross server-client).
	  Net      -> actual server-client communication (RemoteEvents/Functions).
	  Boot     -> the generic engine used by the Loaders to load modules.
	  ECS      -> Entity-Component, optional, see its own _README.

	WHEN TO USE IT
	When you have code that BOTH server and client need (types,
	utilities, constants, Signal/Net themselves).

	WHEN NOT TO USE IT
	If something is 100% server-only (e.g. validating purchases)
	or 100% client-only (e.g. a visual effect), put it in Services or
	Controllers instead of here. Shared is ONLY for what's truly shared.

	IS IT MANDATORY?
	Yes, in the sense that the Loader itself uses it (Boot/ModuleRegistry).
	But you can skip Signal, Net, or ECS if you don't need them: each one
	works independently.
]]

return nil
]==])

local SignalModule = make("ModuleScript", "Signal", Shared)
setSource(SignalModule, [==[
--!strict
--[[
	SIGNAL
	What it is: a simple event, BindableEvent-style but without Instance overhead.
	Why it exists: to communicate Lua modules with each other (same side: server-only
	                or client-only). It does NOT cross the client-server boundary,
	                use Net for that.
	When to use it: when a Service/Controller/System needs to notify others
	               that "something happened" without directly coupling to them.
	When NOT to use it: to talk between server and client (use Net) or if a
	                  simple function call is enough (not everything needs
	                  to be an event).
	Usage example:
		local Signal = require(...)
		local onScoreChanged = Signal.new()
		onScoreChanged:Connect(function(newScore) print(newScore) end)
		onScoreChanged:Fire(10)
	Common mistakes:
		- Forgetting Disconnect() on long-lived Signals -> memory leaks.
		- Using Signal to communicate server-client (doesn't work, use Net).
]]

export type Connection = {
	Connected: boolean,
	Disconnect: (self: Connection) -> (),
}

export type Signal<T...> = {
	Fire: (self: Signal<T...>, T...) -> (),
	Connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	Once: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	Wait: (self: Signal<T...>) -> T...,
	DisconnectAll: (self: Signal<T...>) -> (),
	Destroy: (self: Signal<T...>) -> (),
}

type ConnectionInternal = {
	Connected: boolean,
	_signal: SignalInternal,
	_callback: (...any) -> (),
	_next: ConnectionInternal?,
	_prev: ConnectionInternal?,
}

type SignalInternal = {
	_head: ConnectionInternal?,
	Fire: (self: SignalInternal, ...any) -> (),
	Connect: (self: SignalInternal, callback: (...any) -> ()) -> Connection,
	Once: (self: SignalInternal, callback: (...any) -> ()) -> Connection,
	Wait: (self: SignalInternal) -> ...any,
	DisconnectAll: (self: SignalInternal) -> (),
	Destroy: (self: SignalInternal) -> (),
}

local Connection = {}
Connection.__index = Connection

local function disconnect(self: ConnectionInternal)
	if not self.Connected then
		return
	end
	self.Connected = false

	local signal = self._signal
	if signal._head == self then
		signal._head = self._next
	end
	if self._prev then
		self._prev._next = self._next
	end
	if self._next then
		self._next._prev = self._prev
	end
end
Connection.Disconnect = disconnect

local Signal = {}
Signal.__index = Signal

function Signal.new(): SignalInternal
	local self = setmetatable({
		_head = nil,
	}, Signal)
	return (self :: any) :: SignalInternal
end

function Signal.Connect(self: SignalInternal, callback: (...any) -> ()): Connection
	local connection: ConnectionInternal = setmetatable({
		Connected = true,
		_signal = self,
		_callback = callback,
		_next = self._head,
		_prev = nil,
	}, Connection) :: any

	if self._head then
		self._head._prev = connection
	end
	self._head = connection

	return (connection :: any) :: Connection
end

function Signal.Once(self: SignalInternal, callback: (...any) -> ()): Connection
	local connection: ConnectionInternal
	connection = self:Connect(function(...)
		disconnect(connection)
		callback(...)
	end) :: any
	return (connection :: any) :: Connection
end

function Signal.Fire(self: SignalInternal, ...: any)
	local connection = self._head
	while connection do
		local nextConnection = connection._next
		if connection.Connected then
			task.spawn(connection._callback, ...)
		end
		connection = nextConnection
	end
end

function Signal.Wait(self: SignalInternal): ...any
	local thread = coroutine.running()
	local connection: ConnectionInternal
	connection = self:Connect(function(...)
		disconnect(connection)
		task.spawn(thread, ...)
	end) :: any
	return coroutine.yield()
end

function Signal.DisconnectAll(self: SignalInternal)
	local connection = self._head
	while connection do
		connection.Connected = false
		connection = connection._next
	end
	self._head = nil
end

function Signal.Destroy(self: SignalInternal)
	self:DisconnectAll()
end

return Signal
]==])

local NetModule = make("ModuleScript", "Net", Shared)
setSource(NetModule, [==[
--!strict
--[[
	NET
	What it is: a thin layer over RemoteEvents/RemoteFunctions.
	Why it exists: so you don't have to manually create and hunt down RemoteEvents
	                in the Explorer. Net creates them and caches them for you, by name.
	When to use it: any real communication between server and client
	               (positions, player actions, server results).
	When NOT to use it: to communicate two modules on the SAME side (server-server
	                  or client-client), use Signal, it's cheaper.
	Usage example:
		-- Server
		local damageEvent = Net.Event("PlayerDamaged")
		damageEvent:FireClient(player, 10)
		-- Client
		local damageEvent = Net.Event("PlayerDamaged")
		damageEvent:Connect(function(amount) print(amount) end)
	Common mistakes:
		- Using the same string name for two different events (collision).
		- Calling FireClient from the client, or Fire from the server
		  (each method has a correct side, check the asserts if it fails).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local IS_SERVER = RunService:IsServer()
local REMOTES_FOLDER_NAME = "NetRemotes"

export type NetEvent = {
	Fire: (self: NetEvent, ...any) -> (),
	FireClient: (self: NetEvent, player: Player, ...any) -> (),
	FireAllClients: (self: NetEvent, ...any) -> (),
	FireOtherClients: (self: NetEvent, exclude: Player, ...any) -> (),
	Connect: (self: NetEvent, callback: (...any) -> ()) -> RBXScriptConnection,
}

export type NetFunction = {
	Invoke: (self: NetFunction, ...any) -> ...any,
	SetCallback: (self: NetFunction, callback: (player: Player, ...any) -> ...any) -> (),
}

type NetEventInternal = {
	_remote: RemoteEvent,
}

type NetFunctionInternal = {
	_remote: RemoteFunction,
}

local remotesFolder: Folder

if IS_SERVER then
	local folder = Instance.new("Folder")
	folder.Name = REMOTES_FOLDER_NAME
	folder.Parent = ReplicatedStorage
	remotesFolder = folder
else
	remotesFolder = ReplicatedStorage:WaitForChild(REMOTES_FOLDER_NAME) :: Folder
end

local function getOrCreateRemoteEvent(name: string): RemoteEvent
	if IS_SERVER then
		local existing = remotesFolder:FindFirstChild(name)
		if existing then
			return existing :: RemoteEvent
		end
		local remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = remotesFolder
		return remote
	end
	return remotesFolder:WaitForChild(name) :: RemoteEvent
end

local function getOrCreateRemoteFunction(name: string): RemoteFunction
	if IS_SERVER then
		local existing = remotesFolder:FindFirstChild(name)
		if existing then
			return existing :: RemoteFunction
		end
		local remote = Instance.new("RemoteFunction")
		remote.Name = name
		remote.Parent = remotesFolder
		return remote
	end
	return remotesFolder:WaitForChild(name) :: RemoteFunction
end

local NetEvent = {}
NetEvent.__index = NetEvent

function NetEvent:Fire(...: any)
	assert(not IS_SERVER, "Net: Fire is only called from the client, use FireClient/FireAllClients on the server")
	self._remote:FireServer(...)
end

function NetEvent:FireClient(player: Player, ...: any)
	assert(IS_SERVER, "Net: FireClient is only called from the server")
	self._remote:FireClient(player, ...)
end

function NetEvent:FireAllClients(...: any)
	assert(IS_SERVER, "Net: FireAllClients is only called from the server")
	self._remote:FireAllClients(...)
end

function NetEvent:FireOtherClients(exclude: Player, ...: any)
	assert(IS_SERVER, "Net: FireOtherClients is only called from the server")
	for _, player in Players:GetPlayers() do
		if player ~= exclude then
			self._remote:FireClient(player, ...)
		end
	end
end

function NetEvent:Connect(callback: (...any) -> ()): RBXScriptConnection
	if IS_SERVER then
		return self._remote.OnServerEvent:Connect(callback)
	end
	return self._remote.OnClientEvent:Connect(callback)
end

local function newNetEvent(name: string): NetEventInternal
	local self = setmetatable({
		_remote = getOrCreateRemoteEvent(name),
	}, NetEvent)
	return (self :: any) :: NetEventInternal
end

local NetFunction = {}
NetFunction.__index = NetFunction

function NetFunction:Invoke(...: any): ...any
	assert(not IS_SERVER, "Net: Invoke is only called from the client")
	return self._remote:InvokeServer(...)
end

function NetFunction:SetCallback(callback: (player: Player, ...any) -> ...any)
	assert(IS_SERVER, "Net: SetCallback is only called from the server")
	self._remote.OnServerInvoke = callback
end

local function newNetFunction(name: string): NetFunctionInternal
	local self = setmetatable({
		_remote = getOrCreateRemoteFunction(name),
	}, NetFunction)
	return (self :: any) :: NetFunctionInternal
end

local eventCache: { [string]: NetEvent } = {}
local functionCache: { [string]: NetFunction } = {}

local Net = {}

function Net.Event(name: string): NetEvent
	local cached = eventCache[name]
	if cached then
		return cached
	end
	local netEvent = (newNetEvent(name) :: any) :: NetEvent
	eventCache[name] = netEvent
	return netEvent
end

function Net.Function(name: string): NetFunction
	local cached = functionCache[name]
	if cached then
		return cached
	end
	local netFunction = (newNetFunction(name) :: any) :: NetFunction
	functionCache[name] = netFunction
	return netFunction
end

return Net
]==])

local SharedBoot = make("Folder", "Boot", Shared)

local ModuleRegistryModule = make("ModuleScript", "ModuleRegistry", SharedBoot)
setSource(ModuleRegistryModule, [==[
--!strict
--[[
	MODULE REGISTRY
	What it is: a generic ModuleScript loader. It doesn't know anything about
	        "Services" or "Controllers", it only knows how to require() a
	        folder and call Init/Start if they exist.
	Why it exists: to avoid repeating the same loading logic in the server
	                Loader and the client Loader.
	When to use it: it's used internally by Boot/Loader (server) and Boot/Loader
	               (client). You almost never need to touch it directly.
	When NOT to use it: if you want to control the exact load order of 2 or 3
	                  specific modules yourself, just do a manual require()
	                  in your Bootstrap, no need to go through here.
	Convention: any ModuleScript in the folder starting with "_" is
	            ignored (used for documentation or to disable a module).
	Common mistakes:
		- A module that doesn't end with "return SomeTable" -> a warning is
		  issued and it's ignored, it doesn't break the rest of the load.
]]

export type Loadable = {
	Name: string,
	Init: ((self: Loadable) -> ())?,
	Start: ((self: Loadable) -> ())?,
	[any]: any,
}

export type Registry = {
	Add: (self: Registry, moduleScript: ModuleScript) -> (),
	AddFolder: (self: Registry, folder: Instance, deep: boolean?) -> (),
	Start: (self: Registry) -> (),
}

type RegistryInternal = {
	_label: string,
	_pending: { ModuleScript },
	_seen: { [ModuleScript]: boolean },
	_loaded: { [string]: Loadable },
}

local Registry = {}
Registry.__index = Registry

function Registry.new(label: string): Registry
	local self: RegistryInternal = setmetatable({
		_label = label,
		_pending = {},
		_seen = {},
		_loaded = {},
	}, Registry) :: any
	return (self :: any) :: Registry
end

function Registry.Add(self: Registry, moduleScript: ModuleScript)
	local internal = (self :: any) :: RegistryInternal
	if internal._seen[moduleScript] then
		return
	end
	internal._seen[moduleScript] = true
	table.insert(internal._pending, moduleScript)
end

function Registry.AddFolder(self: Registry, folder: Instance, deep: boolean?)
	local children = if deep then folder:GetDescendants() else folder:GetChildren()
	for _, child in children do
		-- Names starting with "_" are documentation or disabled
		-- modules: they are never loaded.
		if child:IsA("ModuleScript") and child.Name:sub(1, 1) ~= "_" then
			Registry.Add(self, child)
		end
	end
end

function Registry.Start(self: Registry)
	local internal = (self :: any) :: RegistryInternal

	for _, moduleScript in internal._pending do
		local ok, result = pcall(require, moduleScript)
		if not ok then
			warn(`Framework: failed to load {internal._label} {moduleScript.Name}: {result}`)
			continue
		end
		if typeof(result) ~= "table" then
			warn(
				`Framework: {moduleScript.Name} did not return a table (did you forget the "return" at the end of the file?). This module will be ignored.`
			)
			continue
		end
		internal._loaded[moduleScript.Name] = result :: Loadable
	end

	for name, loadable in internal._loaded do
		if loadable.Init then
			local ok, err = pcall(loadable.Init, loadable)
			if not ok then
				warn(`Framework: failure in Init of {name}: {err}`)
			end
		end
	end

	for name, loadable in internal._loaded do
		if loadable.Start then
			task.spawn(function()
				local ok, err = pcall(loadable.Start, loadable)
				if not ok then
					warn(`Framework: failure in Start of {name}: {err}`)
				end
			end)
		end
	end

	local count = 0
	for _ in internal._loaded do
		count += 1
	end
	print(`Framework: {count} {internal._label}(s) loaded successfully.`)
end

return Registry
]==])

local SharedECS = make("Folder", "ECS", Shared)

local SharedECSReadme = make("ModuleScript", "_README", SharedECS)
setSource(SharedECSReadme, [==[
--!strict
--[[
	ECS (Entity-Component-System) — folder explained

	WHAT IT'S FOR
	An alternative (and 100% optional) way to organize logic that repeats
	across many similar instances: enemies, pickups, doors, etc.
	Instead of one giant Service with lots of "if"s, you split behavior into
	small Systems that operate on any entity that has certain
	Components.

	WHAT'S INSIDE
	  Component      -> defines "data tags" (e.g. Health, Position).
	  World          -> stores which entity has which component and its data.
	  System         -> the type of a System (Init/Update).
	  SystemRegistry -> loads and orders your Systems (used by SystemBootstrap).
	  TagBridge      -> connects CollectionService to the World automatically.

	WHEN TO USE IT
	When you have MANY similar instances with shared behavior
	(dozens or hundreds of enemies, projectiles, pickups...).

	WHEN NOT TO USE IT
	If your game has few systems, or mostly unique things (a boss, a
	menu, a shop), a regular Service/Controller is simpler and
	faster to write. ECS adds a layer of indirection that only pays
	off when there's real repetition.

	IS IT MANDATORY?
	No. You can delete this whole folder and the rest of the framework
	(Services, Controllers, Signal, Net) keeps working exactly the same.

	See also "_TAGS_AND_COLLECTIONSERVICE" in this same folder.
]]

return nil
]==])

local SharedECSTagsDoc = make("ModuleScript", "_TAGS_AND_COLLECTIONSERVICE", SharedECS)
setSource(SharedECSTagsDoc, [==[
--!strict
--[[
	TAGS + COLLECTIONSERVICE — how to organize your Systems with tags

	WHY USE TAGS
	CollectionService lets you put a "tag" on any Instance directly from
	Studio, without writing code. TagBridge listens for those
	tags and automatically creates/destroys World entities when you
	add or remove the tag, even at runtime.

	Without this, you'd have to manually register every enemy/door/object
	you place on the map. With tags, you just add the tag in
	Studio (or via code) and the framework figures it out on its own.

	TYPICAL TAG EXAMPLES
	  "Enemy"         -> any hostile NPC.
	  "NPC"           -> non-hostile characters with dialogue.
	  "Door"          -> doors that open/close.
	  "Interactable"  -> anything the player can interact with (E).
	  "Projectile"    -> bullets/arrows that need movement/damage logic.
	  "Pickup"        -> collectible objects (coins, items).

	HOW TO USE IT (example)
		local TagBridge = require(ReplicatedStorage.Framework.Shared.ECS.TagBridge)
		local HealthComponent = require(path.to.HealthComponent)

		TagBridge.Register(world, "Enemy", function(world, entity, instance)
			world:Set(entity, HealthComponent, { current = 100, max = 100 })
		end)

	WHEN IT'S WORTH IT
	  - You have many instances of the same type scattered across the map.
	  - You want a level designer (without touching code) to be able to
	    place a new enemy just by adding the right tag.

	WHEN IT'S NOT WORTH IT
	  - You have 1 or 2 unique instances (a final boss, a special door).
	    In that case, referencing them directly from a Service is
	    simpler and more direct to read.
	  - Your game doesn't use ECS: TagBridge depends on World, so without
	    ECS this doesn't apply (use CollectionService directly if you still need it).
]]

return nil
]==])

local ComponentModule = make("ModuleScript", "Component", SharedECS)
setSource(ComponentModule, [==[
--!strict
--[[
	COMPONENT
	What it is: a typed "data tag", used to store information in
	        the World (e.g. Health, Position, Owner).
	Why it exists: so World:Set/Get/Has know what type of data
	                you're storing, with autocomplete included.
	When to use it: when defining a new "data type" that several entities
	               can have (e.g. HealthComponent = Component.new("Health")).
	When NOT to use it: a Component has no behavior, only data. If you
	                  need logic, that goes in a System, not here.
	Usage example:
		local HealthComponent = Component.new("Health") :: Component.ComponentDefinition<{current: number, max: number}>
		world:Set(entity, HealthComponent, { current = 100, max = 100 })
]]

export type ComponentDefinition<T> = {
	_name: string,
}

local Component = {}

function Component.new<T>(name: string): ComponentDefinition<T>
	return {
		_name = name,
	} :: ComponentDefinition<T>
end

return Component
]==])

local SharedECSComponents = make("Folder", "Components", SharedECS)
local SharedECSComponentsReadme = make("ModuleScript", "_README", SharedECSComponents)
setSource(SharedECSComponentsReadme, [==[
--!strict
--[[
	COMPONENTS — folder explained

	WHAT IT'S FOR
	Store your Component definitions here (created with Component.new),
	one per ModuleScript, so they're easy to find and reuse from
	any System.

	WHEN TO USE IT
	When using ECS and you need a new shared data type between
	entities (Health, Position, Team, Owner, etc.).

	WHEN NOT TO USE IT
	If you don't use ECS, ignore this folder entirely.

	EXAMPLE
		-- Components/Health.lua
		local Component = require(script.Parent.Parent.Component)
		export type HealthData = { current: number, max: number }
		return Component.new("Health") :: Component.ComponentDefinition<HealthData>

	IS IT MANDATORY?
	No, it's intentionally empty. Only create it if you actually use ECS.
]]

return nil
]==])

local SystemTypeModule = make("ModuleScript", "System", SharedECS)
setSource(SystemTypeModule, [==[
--!strict
--[[
	SYSTEM (type)
	What it is: the shape any System must have (Name, Priority, Init, Update).
	Why it exists: so SystemRegistry knows what to expect from each System, and
	                so you get autocomplete when writing a new one.
	When to use it: when writing a module inside a "Systems" folder,
	               type your table as Types.System.
	When NOT to use it: if you don't use ECS, ignore it.
	Usage example:
		local MySystem: Types.System = { Name = "MySystem", Priority = 0 }
		function MySystem:Update(world, dt) ... end
		return MySystem
]]

local World = require(script.Parent.World)
type World = World.World

export type System = {
	Name: string,
	Priority: number?,
	Init: ((self: System, world: World) -> ())?,
	Update: ((self: System, world: World, deltaTime: number) -> ())?,
}

return {}
]==])

local WorldModule = make("ModuleScript", "World", SharedECS)
setSource(WorldModule, [==[
--!strict
--[[
	WORLD
	What it is: the central store of the ECS. It keeps track of which
	        entities exist and which Component/data each one has.
	Why it exists: so Systems can ask "give me all the entities
	                that have Health and Position" without knowing how
	                they're stored internally.
	When to use it: create one World per side (one for server, one for
	               client; already created in ECS/ServerWorld and ECS/ClientWorld).
	When NOT to use it: if you don't use ECS, ignore it. An empty World costs nothing.
	Usage example:
		local entity = world:CreateEntity()
		world:Set(entity, HealthComponent, { current = 100, max = 100 })
		for entity, health in world:Query(HealthComponent) do
			print(entity, health.current)
		end
	Common mistakes:
		- Using World:Set on an already destroyed entity -> the assert fails on
		  purpose, check the order of your logic.
]]

local Component = require(script.Parent.Component)
type ComponentDefinition<T> = Component.ComponentDefinition<T>

export type Entity = number

type ComponentStorage = {
	sparse: { [Entity]: number },
	dense: { Entity },
	data: { any },
}

export type World = {
	CreateEntity: (self: World) -> Entity,
	IsAlive: (self: World, entity: Entity) -> boolean,
	DestroyEntity: (self: World, entity: Entity) -> (),
	Set: <T>(self: World, entity: Entity, component: ComponentDefinition<T>, data: T) -> (),
	Remove: <T>(self: World, entity: Entity, component: ComponentDefinition<T>) -> (),
	Get: <T>(self: World, entity: Entity, component: ComponentDefinition<T>) -> T?,
	Has: (self: World, entity: Entity, component: ComponentDefinition<any>) -> boolean,
	Query: (self: World, ...ComponentDefinition<any>) -> () -> ...any,
}

type WorldInternal = {
	_nextEntityId: Entity,
	_alive: { [Entity]: boolean },
	_components: { [ComponentDefinition<any>]: ComponentStorage },
}

local World = {}
World.__index = World

local function removeFromStorage(storage: ComponentStorage, entity: Entity)
	local index = storage.sparse[entity]
	if not index then
		return
	end

	local lastIndex = #storage.dense
	local lastEntity = storage.dense[lastIndex]

	storage.dense[index] = lastEntity
	storage.data[index] = storage.data[lastIndex]
	storage.sparse[lastEntity] = index

	storage.dense[lastIndex] = nil :: any
	storage.data[lastIndex] = nil
	storage.sparse[entity] = nil
end

function World.new(): World
	local self: WorldInternal = setmetatable({
		_nextEntityId = 0,
		_alive = {},
		_components = {},
	}, World) :: any
	return (self :: any) :: World
end

function World:CreateEntity(): Entity
	local internal = (self :: any) :: WorldInternal
	internal._nextEntityId += 1
	local entity = internal._nextEntityId
	internal._alive[entity] = true
	return entity
end

function World:IsAlive(entity: Entity): boolean
	local internal = (self :: any) :: WorldInternal
	return internal._alive[entity] == true
end

function World:DestroyEntity(entity: Entity)
	local internal = (self :: any) :: WorldInternal
	if not internal._alive[entity] then
		return
	end
	for _, storage in internal._components do
		removeFromStorage(storage, entity)
	end
	internal._alive[entity] = nil
end

function World:Set<T>(entity: Entity, component: ComponentDefinition<T>, data: T)
	local internal = (self :: any) :: WorldInternal
	assert(internal._alive[entity], "World: the entity does not exist or was destroyed")

	local storage = internal._components[component]
	if not storage then
		storage = { sparse = {}, dense = {}, data = {} }
		internal._components[component] = storage
	end

	local index = storage.sparse[entity]
	if index then
		storage.data[index] = data
	else
		local newIndex = #storage.dense + 1
		storage.dense[newIndex] = entity
		storage.data[newIndex] = data
		storage.sparse[entity] = newIndex
	end
end

function World:Remove<T>(entity: Entity, component: ComponentDefinition<T>)
	local internal = (self :: any) :: WorldInternal
	local storage = internal._components[component]
	if not storage then
		return
	end
	removeFromStorage(storage, entity)
end

function World:Get<T>(entity: Entity, component: ComponentDefinition<T>): T?
	local internal = (self :: any) :: WorldInternal
	local storage = internal._components[component]
	if not storage then
		return nil
	end
	local index = storage.sparse[entity]
	if not index then
		return nil
	end
	return storage.data[index] :: T
end

function World:Has(entity: Entity, component: ComponentDefinition<any>): boolean
	local internal = (self :: any) :: WorldInternal
	local storage = internal._components[component]
	if not storage then
		return false
	end
	return storage.sparse[entity] ~= nil
end

function World:Query(...: ComponentDefinition<any>): () -> ...any
	local internal = (self :: any) :: WorldInternal
	local components = { ... }
	local count = #components

	if count == 0 then
		return function(): any
			return nil
		end
	end

	local storages: { ComponentStorage } = {}
	local smallest: ComponentStorage? = nil
	local smallestSize = math.huge

	for i, component in components do
		local storage = internal._components[component]
		if not storage then
			return function(): any
				return nil
			end
		end
		storages[i] = storage
		local size = #storage.dense
		if size < smallestSize then
			smallestSize = size
			smallest = storage
		end
	end

	local iterStorage = smallest :: ComponentStorage
	local index = 0

	return function(): ...any
		while true do
			index += 1
			if index > #iterStorage.dense then
				return nil
			end

			local entity = iterStorage.dense[index]
			local results: { any } = { entity }
			local matchesAll = true

			for i, storage in storages do
				if storage == iterStorage then
					results[i + 1] = iterStorage.data[index]
				else
					local dataIndex = storage.sparse[entity]
					if not dataIndex then
						matchesAll = false
						break
					end
					results[i + 1] = storage.data[dataIndex]
				end
			end

			if matchesAll then
				return table.unpack(results)
			end
		end
	end
end

return World
]==])

local SystemRegistryModule = make("ModuleScript", "SystemRegistry", SharedECS)
setSource(SystemRegistryModule, [==[
--!strict
--[[
	SYSTEM REGISTRY
	What it is: the System loader (equivalent to ModuleRegistry, but for
	        Systems: it orders them by Priority and connects them to Heartbeat).
	Why it exists: so you don't have to write the Heartbeat loop or the
	                execution order of your Systems by hand.
	When to use it: used internally by ECS/SystemLoader (server and client).
	When NOT to use it: if you'd rather control yourself when Update is
	                  called for a specific System, you can ignore it and call it manually.
	Convention: ModuleScripts starting with "_" are ignored (documentation
	            or an intentionally disabled System).
	Common mistakes:
		- A System without a "Name" field (string) -> a warning is issued and
		  it's ignored, instead of breaking the order of all the others.
]]

local RunService = game:GetService("RunService")

local Types = require(script.Parent.System)
local World = require(script.Parent.World)
type World = World.World

export type Registry = {
	Add: (self: Registry, moduleScript: ModuleScript) -> (),
	AddFolder: (self: Registry, folder: Instance, deep: boolean?) -> (),
	Start: (self: Registry, world: World) -> (),
}

type RegistryInternal = {
	_label: string,
	_pending: { ModuleScript },
	_seen: { [ModuleScript]: boolean },
	_loaded: { Types.System },
}

local Registry = {}
Registry.__index = Registry

function Registry.new(label: string): Registry
	local self: RegistryInternal = setmetatable({
		_label = label,
		_pending = {},
		_seen = {},
		_loaded = {},
	}, Registry) :: any
	return (self :: any) :: Registry
end

function Registry.Add(self: Registry, moduleScript: ModuleScript)
	local internal = (self :: any) :: RegistryInternal
	if internal._seen[moduleScript] then
		return
	end
	internal._seen[moduleScript] = true
	table.insert(internal._pending, moduleScript)
end

function Registry.AddFolder(self: Registry, folder: Instance, deep: boolean?)
	local children = if deep then folder:GetDescendants() else folder:GetChildren()
	for _, child in children do
		-- Names starting with "_" are documentation or intentionally
		-- disabled Systems: they are never loaded.
		if child:IsA("ModuleScript") and child.Name:sub(1, 1) ~= "_" then
			Registry.Add(self, child)
		end
	end
end

function Registry.Start(self: Registry, world: World)
	local internal = (self :: any) :: RegistryInternal

	for _, moduleScript in internal._pending do
		local ok, result = pcall(require, moduleScript)
		if not ok then
			warn(`Framework: failed to load {internal._label} {moduleScript.Name}: {result}`)
			continue
		end
		if typeof(result) ~= "table" then
			warn(
				`Framework: {moduleScript.Name} did not return a table (did you forget the "return" at the end of the file?). This System will be ignored.`
			)
			continue
		end
		local system = result :: Types.System
		if typeof(system.Name) ~= "string" then
			warn(`Framework: the System in {moduleScript.Name} has no "Name" field (string). It will be ignored.`)
			continue
		end
		table.insert(internal._loaded, system)
	end

	table.sort(internal._loaded, function(a: Types.System, b: Types.System): boolean
		local priorityA = a.Priority or 0
		local priorityB = b.Priority or 0
		if priorityA == priorityB then
			return a.Name < b.Name
		end
		return priorityA < priorityB
	end)

	for _, system in internal._loaded do
		if system.Init then
			local ok, err = pcall(system.Init, system, world)
			if not ok then
				warn(`Framework: failure in Init of {system.Name}: {err}`)
			end
		end
	end

	print(`Framework: {#internal._loaded} {internal._label}(s) loaded successfully.`)

	RunService.Heartbeat:Connect(function(deltaTime: number)
		for _, system in internal._loaded do
			if system.Update then
				local ok, err = pcall(system.Update, system, world, deltaTime)
				if not ok then
					warn(`Framework: failure in Update of {system.Name}: {err}`)
				end
			end
		end
	end)
end

return Registry
]==])

local TagBridgeModule = make("ModuleScript", "TagBridge", SharedECS)
setSource(TagBridgeModule, [==[
--!strict
--[[
	TAG BRIDGE
	What it is: a bridge between CollectionService (tags placed in Studio or
	        added by code) and the ECS World. It automatically creates an
	        entity when an instance with the tag appears, and destroys it
	        when the tag is removed or the instance is destroyed.
	Why it exists: so you don't have to manually register every enemy/door/
	                object that exists on the map.
	When to use it: when you use ECS and have many repeated instances with
	               the same tag (see "_TAGS_AND_COLLECTIONSERVICE" in Shared/ECS).
	When NOT to use it: for 1 or 2 unique instances, it's simpler to register
	                  them by hand or use a regular Service.
	Usage example:
		TagBridge.Register(world, "Enemy", function(world, entity, instance)
			world:Set(entity, HealthComponent, { current = 100, max = 100 })
		end, function(world, entity, instance)
			print("Enemy removed:", instance.Name)
		end)
]]

local CollectionService = game:GetService("CollectionService")

local World = require(script.Parent.World)
type World = World.World
type Entity = World.Entity

export type OnAdded = (world: World, entity: Entity, instance: Instance) -> ()
export type OnRemoved = (world: World, entity: Entity, instance: Instance) -> ()

local TagBridge = {}

function TagBridge.Register(world: World, tag: string, onAdded: OnAdded, onRemoved: OnRemoved?)
	local entityByInstance: { [Instance]: Entity } = {}

	local function handleAdded(instance: Instance)
		if entityByInstance[instance] then
			return
		end
		local entity = world:CreateEntity()
		entityByInstance[instance] = entity
		onAdded(world, entity, instance)
	end

	local function handleRemoved(instance: Instance)
		local entity = entityByInstance[instance]
		if not entity then
			return
		end
		entityByInstance[instance] = nil
		if onRemoved then
			onRemoved(world, entity, instance)
		end
		if world:IsAlive(entity) then
			world:DestroyEntity(entity)
		end
	end

	CollectionService:GetInstanceAddedSignal(tag):Connect(handleAdded)
	CollectionService:GetInstanceRemovedSignal(tag):Connect(handleRemoved)

	for _, instance in CollectionService:GetTagged(tag) do
		handleAdded(instance)
	end
end

return TagBridge
]==])

-- ============================================================
-- ServerScriptService/Framework
-- ============================================================

local SSS_Framework = make("Folder", "Framework", ServerScriptService)

local SSS_FrameworkReadme = make("ModuleScript", "_README", SSS_Framework)
setSource(SSS_FrameworkReadme, [==[
--!strict
--[[
	FRAMEWORK (SERVER) — folder explained

	WHAT'S INSIDE
	  Boot/Loader   -> automatically starts everything in "Services".
	  Services/     -> YOUR SERVICES GO HERE. One per ModuleScript.
	  ECS/          -> server World + server Systems bootstrap.
	  ECS/Systems/  -> YOUR SERVER SYSTEMS GO HERE (if you use ECS).

	NOTHING IS MANDATORY
	If you don't use ECS, delete the whole ECS folder: Services keeps working.
	If you don't use Services, delete Boot and Services: nothing else depends on that.

	See Services/_README and ECS/Systems/_README for more detail on each.
]]

return nil
]==])

local SSS_Boot = make("Folder", "Boot", SSS_Framework)

local ServerLoaderModule = make("ModuleScript", "Loader", SSS_Boot)
setSource(ServerLoaderModule, [==[
--!strict
--[[
	LOADER (server)
	What it is: starts the Services. When you call Loader.Start(), it looks
	        for the "Services" folder next to it (ServerScriptService/Framework/Services)
	        and does require() on every ModuleScript there.
	Why it exists: so you only have to write your Service and forget about
	                connecting it to anything, it connects itself.
	When to use it: already connected by Bootstrap, you don't need to call it
	               yourself. Only use Loader.AddServices(folder) if you want
	               to load Services from ANOTHER folder besides the default one.
	When NOT to use it: if you'd rather require your Services by hand one by
	                  one (for example to control the exact order), you can
	                  ignore this Loader and do require() yourself from
	                  another Script.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModuleRegistry = require(ReplicatedStorage.Framework.Shared.Boot.ModuleRegistry)

local registry = ModuleRegistry.new("Service")
local started = false

local Loader = {}

function Loader.AddServices(folder: Instance)
	registry:AddFolder(folder, false)
end

function Loader.AddServicesDeep(folder: Instance)
	registry:AddFolder(folder, true)
end

function Loader.Start()
	if started then
		return
	end
	started = true

	task.defer(function()
		local defaultFolder = script.Parent.Parent:FindFirstChild("Services")
		if defaultFolder then
			registry:AddFolder(defaultFolder, false)
		end
		registry:Start()
	end)
end

return Loader
]==])

local ServerBootstrapScript = make("Script", "Bootstrap", SSS_Boot)
setSource(ServerBootstrapScript, [==[
--!strict
-- BOOTSTRAP (server)
-- This regular Script is the single real entry point.
-- Its only job is to start the Loader, which in turn loads your Services.
-- If you ever want to change HOW everything starts, this is the file to touch.

local Loader = require(script.Parent.Loader)

Loader.Start()
]==])

local SSS_Services = make("Folder", "Services", SSS_Framework)
local SSS_ServicesReadme = make("ModuleScript", "_README", SSS_Services)
setSource(SSS_ServicesReadme, [==[
--!strict
--[[
	SERVICES — folder explained

	WHAT IT'S FOR
	Every ModuleScript in this folder is a "Service": a server module
	with Init (called once when everything starts) and Start (called after,
	on its own thread). They load and start themselves, you don't have to
	register them anywhere.

	WHEN TO USE IT
	For any server logic you want organized into a named module:
	economy, data saving, spawns, matchmaking, etc.

	WHEN NOT TO USE IT
	If it's a small, one-off script that doesn't need Init/Start (for example,
	a configuration script that runs once), a regular Script somewhere else
	is also valid. Don't force everything to be a Service.

	IS IT MANDATORY?
	No. You can empty this folder and use regular Scripts if you prefer.

	REAL EXAMPLE
		-- Services/CoinService.lua
		local CoinService = { Name = "CoinService" }

		function CoinService:Init()
			self.coinsByPlayer = {}
		end

		function CoinService:Start()
			game.Players.PlayerAdded:Connect(function(player)
				self.coinsByPlayer[player.UserId] = 0
			end)
		end

		return CoinService

	COMMON MISTAKE
	Forgetting the "return CoinService" at the end: the Loader will warn
	instead of failing silently.
]]

return nil
]==])

local ServerECS = make("Folder", "ECS", SSS_Framework)

local ServerWorldModule = make("ModuleScript", "ServerWorld", ServerECS)
setSource(ServerWorldModule, [==[
--!strict
--[[
	SERVER WORLD
	What it is: the (ECS) World on the server side. A new, empty World,
	        ready for your server Systems to store entities in it.
	Why it exists: so all server Systems share the
	                same World without having to pass it around manually.
	When to use it: require(script.Parent.ServerWorld) from any server
	               System (or from a Service, if it needs to read the World).
	When NOT to use it: if you don't use ECS on the server, ignore this file.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local World = require(ReplicatedStorage.Framework.Shared.ECS.World)

return World.new()
]==])

local ServerSystemLoaderModule = make("ModuleScript", "SystemLoader", ServerECS)
setSource(ServerSystemLoaderModule, [==[
--!strict
--[[
	SYSTEM LOADER (server)
	What it is: the equivalent of Boot/Loader but for server ECS Systems.
	Why it exists: automatically starts everything in ECS/Systems and
	                connects them to the ServerWorld.
	When to use it: already connected by SystemBootstrap, you don't need to
	               call it directly unless you want to load Systems from
	               another folder with SystemLoader.AddSystems(folder).
	When NOT to use it: if you don't use ECS, ignore this file (nothing runs
	                  if the "Systems" folder is empty).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SystemRegistry = require(ReplicatedStorage.Framework.Shared.ECS.SystemRegistry)
local World = require(ReplicatedStorage.Framework.Shared.ECS.World)
type World = World.World

local registry = SystemRegistry.new("server System")
local started = false

local SystemLoader = {}

function SystemLoader.AddSystems(folder: Instance)
	registry:AddFolder(folder, false)
end

function SystemLoader.AddSystemsDeep(folder: Instance)
	registry:AddFolder(folder, true)
end

function SystemLoader.Start(world: World)
	if started then
		return
	end
	started = true

	task.defer(function()
		local defaultFolder = script.Parent:FindFirstChild("Systems")
		if defaultFolder then
			registry:AddFolder(defaultFolder, false)
		end
		registry:Start(world)
	end)
end

return SystemLoader
]==])

local ServerSystemBootstrapScript = make("Script", "SystemBootstrap", ServerECS)
setSource(ServerSystemBootstrapScript, [==[
--!strict
-- SYSTEM BOOTSTRAP (server)
-- Starts the SystemLoader with the ServerWorld. Same as Boot/Bootstrap but
-- for the ECS side. If you don't use ECS, this script does nothing harmful:
-- it simply won't find any Systems to load.

local SystemLoader = require(script.Parent.SystemLoader)
local ServerWorld = require(script.Parent.ServerWorld)

SystemLoader.Start(ServerWorld)
]==])

local ServerSystems = make("Folder", "Systems", ServerECS)

local ServerSystemsReadme = make("ModuleScript", "_README", ServerSystems)
setSource(ServerSystemsReadme, [==[
--!strict
--[[
	SYSTEMS (server) — folder explained

	WHAT IT'S FOR
	Every ModuleScript here is a System: logic that runs every frame
	(Heartbeat) over the ServerWorld's entities that have certain
	Components. They load and order themselves by "Priority".

	WHEN TO USE IT
	When you have behavior that repeats across many entities: damage,
	projectile movement, health regen, simple AI, etc.

	WHEN NOT TO USE IT
	For logic that only happens once or doesn't fit "per entity
	with such Component", a regular Service is more direct.

	IS IT MANDATORY?
	No, this folder can stay empty if you don't use ECS on the server.

	REAL EXAMPLE
		-- Systems/RegenSystem.lua
		local RegenSystem = { Name = "RegenSystem", Priority = 10 }

		function RegenSystem:Update(world, dt)
			for entity, health in world:Query(HealthComponent) do
				health.current = math.min(health.max, health.current + 1 * dt)
			end
		end

		return RegenSystem
]]

return nil
]==])

local BootHealthCheckModule = make("ModuleScript", "BootHealthCheck", ServerSystems)
setSource(BootHealthCheckModule, [==[
--!strict
--[[
	BOOT HEALTH CHECK
	What it is: a tiny example System that just confirms via console
	        that the server ECS started without errors.
	Why it exists: as a quick reference for "what a real System looks like" and
	                to immediately detect if something broke the load.
	When to use it: you don't need it for anything functional, it's just an
	               example / canary. You can safely delete it.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Framework.Shared.ECS.System)

local BootHealthCheck: Types.System = {
	Name = "BootHealthCheck",
	Priority = 0,
}

function BootHealthCheck:Init()
	print("Framework: server ECS active, no load errors.")
end

return BootHealthCheck
]==])

-- ============================================================
-- StarterPlayer/StarterPlayerScripts/Framework
-- ============================================================

local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")
local SPS_Framework = make("Folder", "Framework", StarterPlayerScripts)

local SPS_FrameworkReadme = make("ModuleScript", "_README", SPS_Framework)
setSource(SPS_FrameworkReadme, [==[
--!strict
--[[
	FRAMEWORK (CLIENT) — folder explained

	WHAT'S INSIDE
	  Boot/Loader     -> automatically starts everything in "Controllers".
	  Controllers/    -> YOUR CONTROLLERS GO HERE. One per ModuleScript.
	  ECS/            -> client World + client Systems bootstrap.
	  ECS/Systems/    -> YOUR CLIENT SYSTEMS GO HERE (if you use ECS).

	This is the exact mirror of ServerScriptService/Framework, but for the
	client: Controllers instead of Services, same loading pattern.

	See Controllers/_README and ECS/Systems/_README for more detail.
]]

return nil
]==])

local SPS_Boot = make("Folder", "Boot", SPS_Framework)

local ClientLoaderModule = make("ModuleScript", "Loader", SPS_Boot)
setSource(ClientLoaderModule, [==[
--!strict
--[[
	LOADER (client)
	What it is: the exact equivalent of the server Loader, but it starts
	        "Controllers" instead of "Services".
	When to use it: already connected by Bootstrap. Use
	               Loader.AddControllers(folder) only if you want to load
	               Controllers from another folder besides the default one.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ModuleRegistry = require(ReplicatedStorage.Framework.Shared.Boot.ModuleRegistry)

local registry = ModuleRegistry.new("Controller")
local started = false

local Loader = {}

function Loader.AddControllers(folder: Instance)
	registry:AddFolder(folder, false)
end

function Loader.AddControllersDeep(folder: Instance)
	registry:AddFolder(folder, true)
end

function Loader.Start()
	if started then
		return
	end
	started = true

	task.defer(function()
		local defaultFolder = script.Parent.Parent:FindFirstChild("Controllers")
		if defaultFolder then
			registry:AddFolder(defaultFolder, false)
		end
		registry:Start()
	end)
end

return Loader
]==])

local ClientBootstrapScript = make("LocalScript", "Bootstrap", SPS_Boot)
setSource(ClientBootstrapScript, [==[
--!strict
-- BOOTSTRAP (client)
-- Same as the server Bootstrap: starts the Loader, which loads your
-- Controllers. The only entry point on the client side.

local Loader = require(script.Parent.Loader)

Loader.Start()
]==])

local SPS_Controllers = make("Folder", "Controllers", SPS_Framework)
local SPS_ControllersReadme = make("ModuleScript", "_README", SPS_Controllers)
setSource(SPS_ControllersReadme, [==[
--!strict
--[[
	CONTROLLERS — folder explained

	WHAT IT'S FOR
	The client equivalent of "Services": every ModuleScript here
	is a Controller with Init/Start, meant for UI, camera, input,
	visual effects, or any client-only logic.

	WHEN TO USE IT
	To organize client logic into named modules: inventory
	UI, camera controls, sound effects, HUD, etc.

	WHEN NOT TO USE IT
	For a small, one-off LocalScript that doesn't need Init/Start, a
	regular LocalScript somewhere else is also valid.

	IS IT MANDATORY?
	No. You can empty this folder and use regular LocalScripts if you prefer.

	REAL EXAMPLE
		-- Controllers/HudController.lua
		local HudController = { Name = "HudController" }

		function HudController:Start()
			print("HUD ready")
		end

		return HudController
]]

return nil
]==])

local ClientECS = make("Folder", "ECS", SPS_Framework)

local ClientWorldModule = make("ModuleScript", "ClientWorld", ClientECS)
setSource(ClientWorldModule, [==[
--!strict
--[[
	CLIENT WORLD
	What it is: the (ECS) World on the client side, independent of the ServerWorld.
	Why it exists: so the client's visual simulation (effects,
	                prediction, animations) has its own ECS state,
	                without mixing with the server's real World.
	When to use it: require(script.Parent.ClientWorld) from client
	               Systems or Controllers that need to read/write ECS.
	When NOT to use it: if you don't use ECS on the client, ignore this file.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local World = require(ReplicatedStorage.Framework.Shared.ECS.World)

return World.new()
]==])

local ClientSystemLoaderModule = make("ModuleScript", "SystemLoader", ClientECS)
setSource(ClientSystemLoaderModule, [==[
--!strict
--[[
	SYSTEM LOADER (client)
	What it is: identical to the server SystemLoader, but starts the
	        ECS/Systems Systems on the client against the ClientWorld.
	When to use it: already connected by SystemBootstrap. Use
	               SystemLoader.AddSystems(folder) only to load Systems
	               from an additional folder.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SystemRegistry = require(ReplicatedStorage.Framework.Shared.ECS.SystemRegistry)
local World = require(ReplicatedStorage.Framework.Shared.ECS.World)
type World = World.World

local registry = SystemRegistry.new("client System")
local started = false

local SystemLoader = {}

function SystemLoader.AddSystems(folder: Instance)
	registry:AddFolder(folder, false)
end

function SystemLoader.AddSystemsDeep(folder: Instance)
	registry:AddFolder(folder, true)
end

function SystemLoader.Start(world: World)
	if started then
		return
	end
	started = true

	task.defer(function()
		local defaultFolder = script.Parent:FindFirstChild("Systems")
		if defaultFolder then
			registry:AddFolder(defaultFolder, false)
		end
		registry:Start(world)
	end)
end

return SystemLoader
]==])

local ClientSystemBootstrapScript = make("LocalScript", "SystemBootstrap", ClientECS)
setSource(ClientSystemBootstrapScript, [==[
--!strict
-- SYSTEM BOOTSTRAP (client)
-- Starts the SystemLoader with the ClientWorld. If you don't use ECS on the
-- client, this script does nothing harmful: it simply finds no Systems.

local SystemLoader = require(script.Parent.SystemLoader)
local ClientWorld = require(script.Parent.ClientWorld)

SystemLoader.Start(ClientWorld)
]==])

local ClientSystems = make("Folder", "Systems", ClientECS)

local ClientSystemsReadme = make("ModuleScript", "_README", ClientSystems)
setSource(ClientSystemsReadme, [==[
--!strict
--[[
	SYSTEMS (client) — folder explained

	WHAT IT'S FOR
	Same as server Systems, but they run on the client over the
	ClientWorld: visual effects, animations, movement prediction,
	particles tied to Components, etc.

	WHEN TO USE IT
	When you have visual effects/behavior that repeats across many
	client entities.

	WHEN NOT TO USE IT
	For UI or client logic that isn't "per entity", use a regular
	Controller instead, it's simpler.

	IS IT MANDATORY?
	No, it can stay empty if you don't use ECS on the client.
]]

return nil
]==])

-- ============================================================

ChangeHistoryService:SetWaypoint("Framework generated (with documentation)")
print("Framework generated successfully. Check the Explorer: every important folder has its own '_README'.")
