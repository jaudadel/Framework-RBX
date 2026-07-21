--!strict
-- FRAMEWORK BUILDER con documentación integrada
-- Pegar completo en la Command Bar de Roblox Studio (View > Command Bar)

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
	FRAMEWORK — LÉEME PRIMERO

	¿QUÉ ES ESTO?
	Una caja de herramientas para hacer juegos en Roblox. NO es un framework al
	estilo Knit/Aero que te obliga a organizar todo tu juego de una forma concreta.
	Aquí no hay nada obligatorio: usa solo lo que te sirva, ignora el resto.

	REGLA DE ORO
	Ninguna pieza depende de que uses las demás.
	  - ¿Solo quieres Signal?              Copia ReplicatedStorage/Framework/Shared/Signal y ya.
	  - ¿Solo quieres Net (RemoteEvents)?  Copia Shared/Net y ya.
	  - ¿Solo quieres Services/Controllers pero no ECS?  Perfecto, ignora la carpeta ECS.
	  - ¿Solo quieres ECS pero no Services?               Perfecto, ignora Services/Controllers.
	Ver "_MODULOS_PORTABLES" (en esta misma carpeta) para saber exactamente qué se
	puede copiar de forma aislada.

	MAPA RÁPIDO (dónde está cada cosa)

	ReplicatedStorage/Framework
	  Types                -> tipos compartidos (Service/Controller), solo para el editor.
	  Shared/Signal         -> eventos internos (Lua puro, sin RemoteEvents).
	  Shared/Net            -> comunicación cliente-servidor (RemoteEvents/Functions).
	  Shared/Boot/ModuleRegistry -> el motor genérico que carga Services y Controllers.
	  Shared/ECS            -> sistema de Entidades-Componentes (World, System, TagBridge).

	ServerScriptService/Framework
	  Boot/Loader           -> arranca tus Services.
	  Services/             -> AQUÍ VAN TUS SERVICIOS (uno por ModuleScript).
	  ECS/                  -> World del servidor + arranque de Systems del servidor.
	  ECS/Systems/          -> AQUÍ VAN TUS SYSTEMS DE SERVIDOR.

	StarterPlayerScripts/Framework
	  Boot/Loader           -> arranca tus Controllers.
	  Controllers/          -> AQUÍ VAN TUS CONTROLLERS (uno por ModuleScript).
	  ECS/                  -> World del cliente + arranque de Systems del cliente.
	  ECS/Systems/          -> AQUÍ VAN TUS SYSTEMS DE CLIENTE.

	CÓMO SE CARGA TODO
	Cada Bootstrap (un Script/LocalScript normal) llama a su Loader. El Loader
	busca automáticamente la carpeta "Services"/"Controllers"/"Systems" que
	está a su lado y hace require() de cada ModuleScript que encuentre ahí
	(ignorando los que empiecen con "_", que son documentación).
	No hay magia oculta: si quieres ver exactamente qué pasa, abre
	Shared/Boot/ModuleRegistry o ECS/SystemRegistry, tienen menos de 100 líneas.

	CONVENCIÓN DEL GUION BAJO "_"
	Cualquier ModuleScript que empiece con "_" (como este mismo archivo) es
	documentación o está desactivado a propósito. El framework nunca lo requiere
	ni lo ejecuta. Puedes usarlo también para "apagar" un Service/Controller/System
	sin borrarlo: solo pon un "_" delante de su nombre.

	SI SOLO TIENES 5 MINUTOS
	1. Mira las carpetas "Services", "Controllers" y "ECS/Systems": ahí es donde
	   vas a escribir código todos los días.
	2. Cada carpeta importante tiene su propio "_README" explicando cuándo usarla
	   y cuándo no. Ábrelos si tienes dudas de una carpeta en concreto.
	3. Lee "_COMO_ESCALAR" cuando el proyecto empiece a crecer.

	Este archivo no hace nada, es solo texto. No lo requieras (require) desde tu código.
]]

return nil
]==])

local RS_FrameworkComoEscalar = make("ModuleScript", "_COMO_ESCALAR", RS_Framework)
setSource(RS_FrameworkComoEscalar, [==[
--!strict
--[[
	CÓMO ESCALAR CON ESTE FRAMEWORK

	Esto no es teoría, son recomendaciones prácticas según tu situación.
	Recuerda: nada de esto es obligatorio, son solo sugerencias.

	SI TU JUEGO TIENE POCOS SISTEMAS (un prototipo, un jam, un juego pequeño)
	  - No uses ECS. Usa Services y Controllers normales, o ni eso: un par de
	    Scripts sueltos también es válido si el proyecto es pequeño.
	  - No te compliques con Components/World, es más código del que necesitas.

	SI TU JUEGO TIENE CIENTOS DE SISTEMAS (muchos NPCs, objetos, mecánicas)
	  - Ahí es donde ECS empieza a valer la pena: World + Systems te evita
	    tener un Service gigante con "if enemy then ... elseif npc then ...".
	  - Usa TagBridge + CollectionService para no tener que registrar cada
	    instancia a mano (ver "_TAGS_Y_COLLECTIONSERVICE" dentro de Shared/ECS).

	SI TRABAJAS SOLO
	  - Prioriza lo que entiendas rápido en 6 meses, no lo "más correcto".
	    Menos carpetas, menos capas. Un par de Services grandes está bien.

	SI TIENES UN EQUIPO
	  - Divide por Services/Controllers/Systems: cada persona puede tocar su
	    propio ModuleScript sin pisar el trabajo de los demás.
	  - Usa nombres de archivo claros (el nombre del ModuleScript ES el nombre
	    del sistema, no hace falta buscar en el código para saber qué es qué).

	SI CONTRATAS UN SCRIPTER O ALGUIEN NUEVO SE UNE
	  - Mándale directo a este "_README" de la carpeta Framework.
	  - Todo se explica solo con abrir el Explorer, no hace falta documentación
	    externa ni un Notion con 40 páginas.

	SI USAS COLLECTIONSERVICE (tags en Studio)
	  - Ver "_TAGS_Y_COLLECTIONSERVICE" en Shared/ECS. Resumen: tags + TagBridge
	    para cosas que se repiten mucho (enemigos, puertas, objetos recogibles).
	    Para cosas únicas (un jefe final, un menú) no hace falta, usa un Service normal.

	REGLA GENERAL PARA DECIDIR SI AÑADIR ALGO
	Pregúntate: "¿esto hace que termine mi juego antes?". Si la respuesta es no,
	no lo añadas todavía. Puedes crecer poco a poco, el framework no te lo impide.
]]

return nil
]==])

local RS_FrameworkModulosPortables = make("ModuleScript", "_MODULOS_PORTABLES", RS_Framework)
setSource(RS_FrameworkModulosPortables, [==[
--!strict
--[[
	MÓDULOS PORTABLES — qué te puedes llevar a otro proyecto

	Copia solo lo que necesites. Esta lista te dice qué depende de qué.

	✅ Shared/Signal
	   100% independiente. Cópialo y pégalo en cualquier proyecto de Roblox.

	✅ Shared/Net
	   100% independiente (solo depende de servicios propios de Roblox:
	   ReplicatedStorage, RunService, Players). Cópialo tal cual.

	✅ Shared/Boot/ModuleRegistry
	   100% independiente. Es un cargador genérico de ModuleScripts, no sabe
	   nada de Services ni de este framework en particular.

	⚠ Shared/ECS (Component, System, World, SystemRegistry, TagBridge)
	   Portable como conjunto, pero los 5 archivos dependen entre sí
	   (World necesita Component, SystemRegistry necesita System y World,
	   TagBridge necesita World). Cópialos TODOS juntos o ninguno.
	   No dependen de Services/Controllers, así que puedes usar ECS sin
	   tocar el resto del framework.

	⚠ Types
	   Portable, pero no aporta nada por sí solo: son solo anotaciones de tipos
	   pensadas para Services/Controllers. Si no usas esas carpetas, no lo necesitas.

	❌ Boot/Loader (servidor y cliente), Bootstrap, SystemBootstrap
	   Estos SÍ están atados a la estructura de carpetas de este framework
	   en concreto (buscan una carpeta "Services"/"Controllers"/"Systems" al
	   lado suyo). Puedes copiarlos, pero tendrás que recrear esa misma
	   estructura de carpetas en el proyecto destino.

	En resumen: si solo quieres un par de utilidades sueltas, quédate con
	Signal, Net y ModuleRegistry. Si quieres el sistema completo de
	Services/Controllers o el ECS, cópialos como bloque completo.
]]

return nil
]==])

local RS_FrameworkIndice = make("ModuleScript", "_INDICE", RS_Framework)
setSource(RS_FrameworkIndice, [==[
--!strict
--[[
	ÍNDICE — EMPIEZA AQUÍ

	Esto es un mapa, no una explicación. Cada pregunta de abajo te dice
	a qué README ir a buscar el detalle. Aquí no se repite nada, solo
	se te señala la puerta correcta.

	¿POR DÓNDE EMPIEZO?
	  -> Framework/_README (aquí al lado). Tiene el mapa completo de
	     carpetas y cómo se carga todo.

	¿DÓNDE CREO UN SERVICE?
	  -> ServerScriptService/Framework/Services (su _README está ahí dentro).

	¿DÓNDE CREO UN CONTROLLER?
	  -> StarterPlayerScripts/Framework/Controllers (su _README está ahí dentro).

	¿QUIERO USAR ECS?
	  -> Shared/ECS/_README. Si vas a usar tags de CollectionService,
	     ver también Shared/ECS/_TAGS_Y_COLLECTIONSERVICE.

	¿QUIERO USAR SIGNAL?
	  -> Shared/Signal (el comentario está al inicio del propio módulo).

	¿QUIERO COMUNICAR CLIENTE Y SERVIDOR?
	  -> Shared/Net (el comentario está al inicio del propio módulo).

	¿QUÉ MÓDULOS SON OPCIONALES?
	  -> Todos, sin excepción. Ver Framework/_README, sección "REGLA DE ORO".

	¿QUÉ MÓDULOS SON PORTABLES?
	  -> Framework/_MODULOS_PORTABLES.

	RECUERDA
	Nada de esto es obligatorio. Usa solo lo que te sirva, ignora el resto.
	El framework se adapta a ti, no al revés.
]]

return nil
]==])

local TypesModule = make("ModuleScript", "Types", RS_Framework)
setSource(TypesModule, [==[
--!strict
--[[
	TYPES
	Qué es: los tipos "Service" y "Controller" que usan los módulos de este framework.
	Por qué existe: para tener autocompletado y avisos del editor (Luau strict).
	Cuándo usarlo: si quieres tipar tus propios Services/Controllers, hazles
	               `local MiServicio: Service = { Name = "MiServicio" }` (opcional).
	Cuándo NO usarlo: no valida nada en tiempo de ejecución. Si no te interesa
	                  tipar nada, ignora este archivo por completo, no rompe nada.
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
	SHARED — carpeta explicada

	PARA QUÉ SIRVE
	Todo lo que vive aquí lo puede usar tanto el servidor como el cliente
	(porque está en ReplicatedStorage). Es donde van las herramientas
	genéricas, no la lógica concreta de tu juego.

	QUÉ HAY DENTRO
	  Signal   -> eventos internos de Lua (no cruza servidor-cliente).
	  Net      -> comunicación real entre servidor y cliente (RemoteEvents/Functions).
	  Boot     -> el motor genérico que usan los Loaders para cargar módulos.
	  ECS      -> Entidades-Componentes, opcional, ver su propio _README.

	CUÁNDO USARLA
	Cuando tengas código que necesiten TANTO el servidor como el cliente
	(tipos, utilidades, constantes, el propio Signal/Net).

	CUÁNDO NO USARLA
	Si algo es 100% exclusivo del servidor (por ejemplo, validar compras)
	o 100% exclusivo del cliente (por ejemplo, un efecto visual), ponlo en
	Services o Controllers en vez de aquí. Shared es SOLO para lo que de
	verdad se comparte.

	¿ES OBLIGATORIA?
	Sí, en el sentido de que el propio Loader la usa (Boot/ModuleRegistry).
	Pero puedes no usar Signal, Net o ECS si no los necesitas: cada uno
	funciona de forma independiente.
]]

return nil
]==])

local SignalModule = make("ModuleScript", "Signal", Shared)
setSource(SignalModule, [==[
--!strict
--[[
	SIGNAL
	Qué es: un evento simple, al estilo BindableEvent pero sin overhead de Instance.
	Por qué existe: para comunicar módulos de Lua entre sí (mismo lado: solo
	                servidor o solo cliente). NO cruza la frontera cliente-servidor,
	                para eso usa Net.
	Cuándo usarlo: cuando un Service/Controller/System necesita avisar a otros
	               de que "algo pasó" sin acoplarse directamente a ellos.
	Cuándo NO usarlo: para hablar entre servidor y cliente (usa Net) o si con
	                  una simple llamada a función te alcanza (no todo necesita
	                  ser un evento).
	Ejemplo de uso:
		local Signal = require(...)
		local onScoreChanged = Signal.new()
		onScoreChanged:Connect(function(newScore) print(newScore) end)
		onScoreChanged:Fire(10)
	Errores comunes:
		- Olvidar Disconnect() en Signals de larga vida -> fugas de memoria.
		- Usar Signal para comunicar servidor-cliente (no funciona, usa Net).
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
	Qué es: una capa fina sobre RemoteEvents/RemoteFunctions.
	Por qué existe: para no tener que crear e ir a buscar RemoteEvents a mano
	                en el Explorer. Net los crea y los cachea por ti, con un nombre.
	Cuándo usarlo: cualquier comunicación real entre servidor y cliente
	               (posiciones, acciones del jugador, resultados del servidor).
	Cuándo NO usarlo: para comunicar dos módulos del MISMO lado (servidor-servidor
	                  o cliente-cliente), usa Signal, es más barato.
	Ejemplo de uso:
		-- Servidor
		local damageEvent = Net.Event("PlayerDamaged")
		damageEvent:FireClient(player, 10)
		-- Cliente
		local damageEvent = Net.Event("PlayerDamaged")
		damageEvent:Connect(function(amount) print(amount) end)
	Errores comunes:
		- Usar el mismo nombre de string para dos eventos distintos (colisión).
		- Llamar FireClient desde el cliente, o Fire desde el servidor
		  (cada método tiene un lado correcto, revisa los asserts si te falla).
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
	assert(not IS_SERVER, "Net: Fire solo se llama del cliente, usa FireClient/FireAllClients en el servidor")
	self._remote:FireServer(...)
end

function NetEvent:FireClient(player: Player, ...: any)
	assert(IS_SERVER, "Net: FireClient solo se llama del servidor")
	self._remote:FireClient(player, ...)
end

function NetEvent:FireAllClients(...: any)
	assert(IS_SERVER, "Net: FireAllClients solo se llama del servidor")
	self._remote:FireAllClients(...)
end

function NetEvent:FireOtherClients(exclude: Player, ...: any)
	assert(IS_SERVER, "Net: FireOtherClients solo se llama del servidor")
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
	assert(not IS_SERVER, "Net: Invoke solo se llama del cliente")
	return self._remote:InvokeServer(...)
end

function NetFunction:SetCallback(callback: (player: Player, ...any) -> ...any)
	assert(IS_SERVER, "Net: SetCallback solo se llama del servidor")
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
	Qué es: un cargador genérico de ModuleScripts. No sabe nada de "Services" ni
	        "Controllers", solo sabe hacer require() de una carpeta y llamar
	        Init/Start si existen.
	Por qué existe: para no repetir la misma lógica de carga en el Loader del
	                servidor y en el del cliente.
	Cuándo usarlo: lo usan internamente Boot/Loader (servidor) y Boot/Loader
	               (cliente). No necesitas tocarlo directamente casi nunca.
	Cuándo NO usarlo: si quieres controlar tú mismo el orden exacto de carga de
	                  2 o 3 módulos concretos, simplemente haz require() manual
	                  en tu Bootstrap, no hace falta pasar por aquí.
	Convención: cualquier ModuleScript de la carpeta que empiece con "_" se
	            ignora (sirve para documentación o para desactivar un módulo).
	Errores comunes:
		- Un módulo que no termina en "return AlgunaTabla" -> se avisa por warn
		  y se ignora, no rompe la carga del resto.
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
		-- Los nombres que empiezan con "_" son documentación o módulos
		-- desactivados a propósito: nunca se cargan.
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
			warn(`Framework: fallo al cargar {internal._label} {moduleScript.Name}: {result}`)
			continue
		end
		if typeof(result) ~= "table" then
			warn(
				`Framework: {moduleScript.Name} no devolvió una tabla (¿olvidaste el "return" al final del archivo?). Se ignorará este módulo.`
			)
			continue
		end
		internal._loaded[moduleScript.Name] = result :: Loadable
	end

	for name, loadable in internal._loaded do
		if loadable.Init then
			local ok, err = pcall(loadable.Init, loadable)
			if not ok then
				warn(`Framework: fallo en Init de {name}: {err}`)
			end
		end
	end

	for name, loadable in internal._loaded do
		if loadable.Start then
			task.spawn(function()
				local ok, err = pcall(loadable.Start, loadable)
				if not ok then
					warn(`Framework: fallo en Start de {name}: {err}`)
				end
			end)
		end
	end

	local count = 0
	for _ in internal._loaded do
		count += 1
	end
	print(`Framework: {count} {internal._label}(s) cargados correctamente.`)
end

return Registry
]==])

local SharedECS = make("Folder", "ECS", Shared)

local SharedECSReadme = make("ModuleScript", "_README", SharedECS)
setSource(SharedECSReadme, [==[
--!strict
--[[
	ECS (Entity-Component-System) — carpeta explicada

	PARA QUÉ SIRVE
	Una forma alternativa (y 100% opcional) de organizar lógica que se repite
	en muchas instancias parecidas: enemigos, objetos recogibles, puertas, etc.
	En vez de un Service enorme con muchos "if", divides el comportamiento en
	Systems pequeños que operan sobre cualquier entidad que tenga ciertos
	Components.

	QUÉ HAY DENTRO
	  Component      -> define "etiquetas de datos" (ej: Health, Position).
	  World          -> guarda qué entidad tiene qué componente y sus datos.
	  System         -> el tipo de un System (Init/Update).
	  SystemRegistry -> carga y ordena tus Systems (lo usan los SystemBootstrap).
	  TagBridge      -> conecta CollectionService con el World automáticamente.

	CUÁNDO USARLA
	Cuando tengas MUCHAS instancias parecidas con comportamiento compartido
	(decenas o cientos de enemigos, proyectiles, recolectables...).

	CUÁNDO NO USARLA
	Si tu juego tiene pocos sistemas, o cosas mayormente únicas (un jefe, un
	menú, una tienda), un Service/Controller normal es más simple y más
	rápido de escribir. ECS añade una capa de indirección que solo vale la
	pena cuando hay repetición real.

	¿ES OBLIGATORIA?
	No. Puedes borrar toda esta carpeta y el resto del framework (Services,
	Controllers, Signal, Net) sigue funcionando exactamente igual.

	Ver también "_TAGS_Y_COLLECTIONSERVICE" en esta misma carpeta.
]]

return nil
]==])

local SharedECSTagsDoc = make("ModuleScript", "_TAGS_Y_COLLECTIONSERVICE", SharedECS)
setSource(SharedECSTagsDoc, [==[
--!strict
--[[
	TAGS + COLLECTIONSERVICE — cómo organizar tus Systems con etiquetas

	POR QUÉ USAR TAGS
	CollectionService te deja poner una "etiqueta" (tag) a cualquier Instance
	desde el propio Studio, sin escribir código. TagBridge escucha esas
	etiquetas y crea/destruye entidades del World automáticamente cuando
	añades o quitas el tag, incluso en runtime.

	Sin esto, tendrías que ir registrando a mano cada enemigo/puerta/objeto
	que colocas en el mapa. Con tags, simplemente les pones la etiqueta en
	Studio (o vía código) y el framework se entera solo.

	EJEMPLOS TÍPICOS DE TAGS
	  "Enemy"         -> cualquier NPC hostil.
	  "NPC"           -> personajes no hostiles con diálogo.
	  "Door"          -> puertas que se abren/cierran.
	  "Interactable"  -> cualquier cosa con la que el jugador puede interactuar (E).
	  "Projectile"    -> balas/flechas que necesitan lógica de movimiento/daño.
	  "Pickup"        -> objetos recogibles (monedas, items).

	CÓMO USARLO (ejemplo)
		local TagBridge = require(ReplicatedStorage.Framework.Shared.ECS.TagBridge)
		local HealthComponent = require(path.to.HealthComponent)

		TagBridge.Register(world, "Enemy", function(world, entity, instance)
			world:Set(entity, HealthComponent, { current = 100, max = 100 })
		end)

	CUÁNDO MERECE LA PENA
	  - Tienes muchas instancias del mismo tipo repartidas por el mapa.
	  - Quieres que un diseñador de niveles (sin tocar código) pueda colocar
	    un enemigo nuevo solo poniéndole el tag correcto.

	CUÁNDO NO MERECE LA PENA
	  - Tienes 1 o 2 instancias únicas (un jefe final, una puerta especial).
	    En ese caso, referenciarlas directamente desde un Service es más
	    simple y más directo de leer.
	  - Tu juego no usa ECS: TagBridge depende de World, así que sin ECS no
	    aplica (usa CollectionService directamente si lo necesitas igualmente).
]]

return nil
]==])

local ComponentModule = make("ModuleScript", "Component", SharedECS)
setSource(ComponentModule, [==[
--!strict
--[[
	COMPONENT
	Qué es: una "etiqueta de datos" tipada, usada para guardar información en
	        el World (ej: Health, Position, Owner).
	Por qué existe: para que World:Set/Get/Has sepan de qué tipo son los datos
	                que estás guardando, con autocompletado incluido.
	Cuándo usarlo: cuando definas un nuevo "tipo de dato" que varias entidades
	               puedan tener (ej: HealthComponent = Component.new("Health")).
	Cuándo NO usarlo: un Component no tiene comportamiento, solo datos. Si
	                  necesitas lógica, esa va en un System, no aquí.
	Ejemplo de uso:
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
	COMPONENTS — carpeta explicada

	PARA QUÉ SIRVE
	Guardar aquí tus definiciones de Component (creadas con Component.new),
	una por ModuleScript, para que sea fácil encontrarlas y reusarlas desde
	cualquier System.

	CUÁNDO USARLA
	Cuando uses ECS y necesites un nuevo tipo de dato compartido entre
	entidades (Health, Position, Team, Owner, etc.).

	CUÁNDO NO USARLA
	Si no usas ECS, ignora esta carpeta por completo.

	EJEMPLO
		-- Components/Health.lua
		local Component = require(script.Parent.Parent.Component)
		export type HealthData = { current: number, max: number }
		return Component.new("Health") :: Component.ComponentDefinition<HealthData>

	¿ES OBLIGATORIA?
	No, está vacía a propósito. Créala solo si de verdad usas ECS.
]]

return nil
]==])

local SystemTypeModule = make("ModuleScript", "System", SharedECS)
setSource(SystemTypeModule, [==[
--!strict
--[[
	SYSTEM (tipo)
	Qué es: la forma que debe tener cualquier System (Name, Priority, Init, Update).
	Por qué existe: para que SystemRegistry sepa qué esperar de cada System, y
	                para que tengas autocompletado al escribir uno nuevo.
	Cuándo usarlo: al escribir un módulo dentro de una carpeta "Systems",
	               tipa tu tabla como Types.System.
	Cuándo NO usarlo: si no usas ECS, ignóralo.
	Ejemplo de uso:
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
	Qué es: el almacén central del ECS. Guarda qué entidades existen y qué
	        Component/datos tiene cada una.
	Por qué existe: para que los Systems puedan preguntar "dame todas las
	                entidades que tengan Health y Position" sin saber cómo
	                están guardadas internamente.
	Cuándo usarlo: crea un World por lado (uno de servidor, uno de cliente;
	               ya vienen creados en ECS/ServerWorld y ECS/ClientWorld).
	Cuándo NO usarlo: si no usas ECS, ignóralo. Un World vacío no cuesta nada.
	Ejemplo de uso:
		local entity = world:CreateEntity()
		world:Set(entity, HealthComponent, { current = 100, max = 100 })
		for entity, health in world:Query(HealthComponent) do
			print(entity, health.current)
		end
	Errores comunes:
		- Usar World:Set en una entidad ya destruida -> falla el assert a propósito,
		  revisa el orden de tu lógica.
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
	assert(internal._alive[entity], "World: la entidad no existe o fue destruida")

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
	Qué es: el cargador de Systems (equivalente a ModuleRegistry, pero para
	        Systems: los ordena por Priority y los conecta a Heartbeat).
	Por qué existe: para que no tengas que escribir a mano el bucle de
	                Heartbeat ni el orden de ejecución de tus Systems.
	Cuándo usarlo: lo usan internamente ECS/SystemLoader (servidor y cliente).
	Cuándo NO usarlo: si prefieres controlar tú mismo cuándo se llama Update
	                  de un System concreto, puedes ignorarlo y llamarlo manual.
	Convención: los ModuleScripts que empiecen con "_" se ignoran (documentación
	            o System desactivado a propósito).
	Errores comunes:
		- Un System sin campo "Name" (string) -> se avisa y se ignora, en vez
		  de romper el orden de todos los demás.
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
		-- Los nombres que empiezan con "_" son documentación o Systems
		-- desactivados a propósito: nunca se cargan.
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
			warn(`Framework: fallo al cargar {internal._label} {moduleScript.Name}: {result}`)
			continue
		end
		if typeof(result) ~= "table" then
			warn(
				`Framework: {moduleScript.Name} no devolvió una tabla (¿olvidaste el "return" al final del archivo?). Se ignorará este System.`
			)
			continue
		end
		local system = result :: Types.System
		if typeof(system.Name) ~= "string" then
			warn(`Framework: el System de {moduleScript.Name} no tiene un campo "Name" (string). Se ignorará.`)
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
				warn(`Framework: fallo en Init de {system.Name}: {err}`)
			end
		end
	end

	print(`Framework: {#internal._loaded} {internal._label}(s) cargados correctamente.`)

	RunService.Heartbeat:Connect(function(deltaTime: number)
		for _, system in internal._loaded do
			if system.Update then
				local ok, err = pcall(system.Update, system, world, deltaTime)
				if not ok then
					warn(`Framework: fallo en Update de {system.Name}: {err}`)
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
	Qué es: un puente entre CollectionService (tags puestos en Studio o por
	        código) y el World del ECS. Crea una entidad automáticamente
	        cuando aparece una instancia con el tag, y la destruye cuando
	        el tag se quita o la instancia se destruye.
	Por qué existe: para no tener que registrar a mano cada enemigo/puerta/
	                objeto que hay en el mapa.
	Cuándo usarlo: cuando uses ECS y tengas muchas instancias repetidas con
	               el mismo tag (ver "_TAGS_Y_COLLECTIONSERVICE" en Shared/ECS).
	Cuándo NO usarlo: para 1 o 2 instancias únicas, es más simple registrarlas
	                  a mano o usar un Service normal.
	Ejemplo de uso:
		TagBridge.Register(world, "Enemy", function(world, entity, instance)
			world:Set(entity, HealthComponent, { current = 100, max = 100 })
		end, function(world, entity, instance)
			print("Enemigo eliminado:", instance.Name)
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
	FRAMEWORK (SERVIDOR) — carpeta explicada

	QUÉ HAY DENTRO
	  Boot/Loader   -> arranca automáticamente todo lo de "Services".
	  Services/     -> AQUÍ VAN TUS SERVICIOS. Uno por ModuleScript.
	  ECS/          -> World del servidor + arranque de Systems del servidor.
	  ECS/Systems/  -> AQUÍ VAN TUS SYSTEMS DE SERVIDOR (si usas ECS).

	NO HAY NADA OBLIGATORIO
	Si no usas ECS, borra la carpeta ECS entera: Services sigue funcionando.
	Si no usas Services, borra Boot y Services: nada más depende de eso.

	Ver Services/_README y ECS/Systems/_README para más detalle de cada una.
]]

return nil
]==])

local SSS_Boot = make("Folder", "Boot", SSS_Framework)

local ServerLoaderModule = make("ModuleScript", "Loader", SSS_Boot)
setSource(ServerLoaderModule, [==[
--!strict
--[[
	LOADER (servidor)
	Qué es: arranca los Services. Al llamar Loader.Start(), busca la carpeta
	        "Services" que está al lado (ServerScriptService/Framework/Services)
	        y hace require() de cada ModuleScript de ahí.
	Por qué existe: para que solo tengas que escribir tu Service y olvidarte
	                de conectarlo a nada, se conecta solo.
	Cuándo usarlo: ya está conectado por Bootstrap, no necesitas llamarlo tú.
	               Solo usa Loader.AddServices(folder) si quieres cargar
	               Services desde OTRA carpeta además de la de por defecto.
	Cuándo NO usarlo: si prefieres requerir tus Services a mano uno por uno
	                  (por ejemplo para controlar el orden exacto), puedes
	                  ignorar este Loader y hacer require() tú mismo desde
	                  otro Script.
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
-- BOOTSTRAP (servidor)
-- Este Script normal y corriente es el único punto de entrada real.
-- Su único trabajo es arrancar el Loader, que a su vez carga tus Services.
-- Si algún día quieres cambiar CÓMO se arranca todo, este es el archivo a tocar.

local Loader = require(script.Parent.Loader)

Loader.Start()
]==])

local SSS_Services = make("Folder", "Services", SSS_Framework)
local SSS_ServicesReadme = make("ModuleScript", "_README", SSS_Services)
setSource(SSS_ServicesReadme, [==[
--!strict
--[[
	SERVICES — carpeta explicada

	PARA QUÉ SIRVE
	Cada ModuleScript de esta carpeta es un "Service": un módulo de servidor
	con Init (se llama una vez al arrancar todos) y Start (se llama después,
	en su propio hilo). Se cargan y arrancan solos, no tienes que registrarlos
	en ningún lado.

	CUÁNDO USARLA
	Para cualquier lógica de servidor que quieras organizada en un módulo con
	nombre propio: economía, guardado de datos, spawns, matchmaking, etc.

	CUÁNDO NO USARLA
	Si es un script único y pequeño que no necesita Init/Start (por ejemplo,
	un script de configuración que corre una vez), un Script normal en otro
	lado también es válido. No fuerces todo a ser un Service.

	¿ES OBLIGATORIA?
	No. Puedes vaciar esta carpeta y usar Scripts normales si lo prefieres.

	EJEMPLO REAL
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

	ERROR COMÚN
	Olvidar el "return CoinService" al final: el Loader avisará por warn en
	vez de fallar en silencio.
]]

return nil
]==])

local ServerECS = make("Folder", "ECS", SSS_Framework)

local ServerWorldModule = make("ModuleScript", "ServerWorld", ServerECS)
setSource(ServerWorldModule, [==[
--!strict
--[[
	SERVER WORLD
	Qué es: el World (ECS) del lado del servidor. Un World nuevo, vacío,
	        listo para que tus Systems de servidor guarden entidades en él.
	Por qué existe: para que todos los Systems de servidor compartan el
	                mismo World sin tener que pasarlo a mano por todos lados.
	Cuándo usarlo: require(script.Parent.ServerWorld) desde cualquier System
	               de servidor (o desde un Service, si necesita leer el World).
	Cuándo NO usarlo: si no usas ECS en el servidor, ignora este archivo.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local World = require(ReplicatedStorage.Framework.Shared.ECS.World)

return World.new()
]==])

local ServerSystemLoaderModule = make("ModuleScript", "SystemLoader", ServerECS)
setSource(ServerSystemLoaderModule, [==[
--!strict
--[[
	SYSTEM LOADER (servidor)
	Qué es: el equivalente a Boot/Loader pero para Systems de ECS del servidor.
	Por qué existe: arranca automáticamente todo lo de ECS/Systems y los
	                conecta al ServerWorld.
	Cuándo usarlo: ya está conectado por SystemBootstrap, no necesitas
	               llamarlo tú directamente salvo que quieras cargar Systems
	               desde otra carpeta con SystemLoader.AddSystems(folder).
	Cuándo NO usarlo: si no usas ECS, ignora este archivo (no se ejecuta nada
	                  si la carpeta "Systems" está vacía).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SystemRegistry = require(ReplicatedStorage.Framework.Shared.ECS.SystemRegistry)
local World = require(ReplicatedStorage.Framework.Shared.ECS.World)
type World = World.World

local registry = SystemRegistry.new("System de servidor")
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
-- SYSTEM BOOTSTRAP (servidor)
-- Arranca el SystemLoader con el ServerWorld. Igual que Boot/Bootstrap pero
-- para el lado de ECS. Si no usas ECS, este script no hace nada dañino:
-- simplemente no encontrará Systems que cargar.

local SystemLoader = require(script.Parent.SystemLoader)
local ServerWorld = require(script.Parent.ServerWorld)

SystemLoader.Start(ServerWorld)
]==])

local ServerSystems = make("Folder", "Systems", ServerECS)

local ServerSystemsReadme = make("ModuleScript", "_README", ServerSystems)
setSource(ServerSystemsReadme, [==[
--!strict
--[[
	SYSTEMS (servidor) — carpeta explicada

	PARA QUÉ SIRVE
	Cada ModuleScript de aquí es un System: lógica que se ejecuta cada frame
	(Heartbeat) sobre las entidades del ServerWorld que tengan ciertos
	Components. Se cargan y ordenan solos por "Priority".

	CUÁNDO USARLA
	Cuando tengas comportamiento que se repite en muchas entidades: daño,
	movimiento de proyectiles, regeneración de vida, IA simple, etc.

	CUÁNDO NO USARLA
	Para lógica que solo pasa una vez o que no encaja en "por cada entidad
	con tal Component", un Service normal es más directo.

	¿ES OBLIGATORIA?
	No, esta carpeta puede quedarse vacía si no usas ECS en el servidor.

	EJEMPLO REAL
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
	Qué es: un System de ejemplo, minúsculo, que solo confirma por consola
	        que el ECS de servidor arrancó sin errores.
	Por qué existe: como referencia rápida de "cómo se ve un System real" y
	                para detectar de inmediato si algo rompió la carga.
	Cuándo usarlo: no lo necesitas para nada funcional, es solo un ejemplo /
	               canario. Puedes borrarlo con total seguridad.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Framework.Shared.ECS.System)

local BootHealthCheck: Types.System = {
	Name = "BootHealthCheck",
	Priority = 0,
}

function BootHealthCheck:Init()
	print("Framework: ECS de servidor activo, sin errores de carga.")
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
	FRAMEWORK (CLIENTE) — carpeta explicada

	QUÉ HAY DENTRO
	  Boot/Loader     -> arranca automáticamente todo lo de "Controllers".
	  Controllers/    -> AQUÍ VAN TUS CONTROLLERS. Uno por ModuleScript.
	  ECS/            -> World del cliente + arranque de Systems del cliente.
	  ECS/Systems/    -> AQUÍ VAN TUS SYSTEMS DE CLIENTE (si usas ECS).

	Es el espejo exacto de ServerScriptService/Framework, pero para el
	cliente: Controllers en vez de Services, mismo patrón de carga.

	Ver Controllers/_README y ECS/Systems/_README para más detalle.
]]

return nil
]==])

local SPS_Boot = make("Folder", "Boot", SPS_Framework)

local ClientLoaderModule = make("ModuleScript", "Loader", SPS_Boot)
setSource(ClientLoaderModule, [==[
--!strict
--[[
	LOADER (cliente)
	Qué es: el equivalente exacto del Loader de servidor, pero arranca
	        "Controllers" en vez de "Services".
	Cuándo usarlo: ya está conectado por Bootstrap. Usa
	               Loader.AddControllers(folder) solo si quieres cargar
	               Controllers desde otra carpeta además de la de por defecto.
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
-- BOOTSTRAP (cliente)
-- Igual que el Bootstrap de servidor: arranca el Loader, que carga tus
-- Controllers. Único punto de entrada del lado del cliente.

local Loader = require(script.Parent.Loader)

Loader.Start()
]==])

local SPS_Controllers = make("Folder", "Controllers", SPS_Framework)
local SPS_ControllersReadme = make("ModuleScript", "_README", SPS_Controllers)
setSource(SPS_ControllersReadme, [==[
--!strict
--[[
	CONTROLLERS — carpeta explicada

	PARA QUÉ SIRVE
	El equivalente de "Services" pero en el cliente: cada ModuleScript aquí
	es un Controller con Init/Start, pensado para UI, cámara, inputs,
	efectos visuales, o cualquier lógica exclusiva del cliente.

	CUÁNDO USARLA
	Para organizar lógica de cliente por módulos con nombre propio: UI de
	inventario, controles de cámara, efectos de sonido, HUD, etc.

	CUÁNDO NO USARLA
	Para un LocalScript pequeño y puntual que no necesita Init/Start, un
	LocalScript normal en otro lado también es válido.

	¿ES OBLIGATORIA?
	No. Puedes vaciar esta carpeta y usar LocalScripts normales si prefieres.

	EJEMPLO REAL
		-- Controllers/HudController.lua
		local HudController = { Name = "HudController" }

		function HudController:Start()
			print("HUD listo")
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
	Qué es: el World (ECS) del lado del cliente, independiente del ServerWorld.
	Por qué existe: para que la simulación visual del cliente (efectos,
	                predicción, animaciones) tenga su propio estado de ECS,
	                sin mezclarse con el World real del servidor.
	Cuándo usarlo: require(script.Parent.ClientWorld) desde Systems o
	               Controllers de cliente que necesiten leer/escribir ECS.
	Cuándo NO usarlo: si no usas ECS en el cliente, ignora este archivo.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local World = require(ReplicatedStorage.Framework.Shared.ECS.World)

return World.new()
]==])

local ClientSystemLoaderModule = make("ModuleScript", "SystemLoader", ClientECS)
setSource(ClientSystemLoaderModule, [==[
--!strict
--[[
	SYSTEM LOADER (cliente)
	Qué es: idéntico al SystemLoader de servidor, pero arranca los Systems
	        de ECS/Systems del cliente contra el ClientWorld.
	Cuándo usarlo: ya está conectado por SystemBootstrap. Usa
	               SystemLoader.AddSystems(folder) solo para cargar Systems
	               desde otra carpeta adicional.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SystemRegistry = require(ReplicatedStorage.Framework.Shared.ECS.SystemRegistry)
local World = require(ReplicatedStorage.Framework.Shared.ECS.World)
type World = World.World

local registry = SystemRegistry.new("System de cliente")
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
-- SYSTEM BOOTSTRAP (cliente)
-- Arranca el SystemLoader con el ClientWorld. Si no usas ECS en el cliente,
-- este script no hace nada dañino: simplemente no encuentra Systems.

local SystemLoader = require(script.Parent.SystemLoader)
local ClientWorld = require(script.Parent.ClientWorld)

SystemLoader.Start(ClientWorld)
]==])

local ClientSystems = make("Folder", "Systems", ClientECS)

local ClientSystemsReadme = make("ModuleScript", "_README", ClientSystems)
setSource(ClientSystemsReadme, [==[
--!strict
--[[
	SYSTEMS (cliente) — carpeta explicada

	PARA QUÉ SIRVE
	Igual que Systems de servidor, pero corren en el cliente sobre el
	ClientWorld: efectos visuales, animaciones, predicción de movimiento,
	partículas ligadas a Components, etc.

	CUÁNDO USARLA
	Cuando tengas efectos/comportamiento visual que se repite en muchas
	entidades del cliente.

	CUÁNDO NO USARLA
	Para UI o lógica de cliente que no es "por entidad", usa un Controller
	normal en su lugar, es más simple.

	¿ES OBLIGATORIA?
	No, puede quedarse vacía si no usas ECS en el cliente.
]]

return nil
]==])

-- ============================================================

ChangeHistoryService:SetWaypoint("Framework generado (con documentación)")
print("Framework generado correctamente. Revisa el Explorer: cada carpeta importante tiene su propio '_README'.")
