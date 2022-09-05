ts.eval("function LuaProjecitle(%pos,%datablock) {%p = new projectile() {datablock= %datablock; initialPosition = %pos;}; %p.explode();}")
ts.eval("function GetCallObject(%obj,%var){eval(\"return \" @ %obj @ \".\" @ %var @ \";\");}")
	
function ts.getPosition(obj) return vector(ts.callobj(obj, "getPosition")) end

function ts.isObject(obj)
	if ts.call("isObject", obj) == "1" then return true
		else return false
	end
end

function ts.sched(time, obj, func, ...)
    ts.call("schedule", time, obj, func, ...)
end

function ts.schedNoQuota(time, obj, func, ...)
    ts.call("scheduleNoQuota", time, obj, func, ...)
end

function ts.objSched(obj, time, func, ...)
    ts.callobj(obj, "schedule", time, func, ...)
end

function ts.objSchedNoQuota(obj, time, func, ...)
    ts.callobj(obj, "scheduleNoQuota", time, func, ...)
end

function ts.getState(obj)
	if ts.isObject(obj) then return ts.callobj(obj,"getState") end
end

function ts.getClassName(obj)
	if ts.isObject(obj) then return ts.callobj(obj,"getClassName") end
end

function ts.talk(string)
	return ts.call("talk",string)
end

function ts.getcallobj(obj,var)
	return ts.call("GetCallObject",obj,var)
end

function ts.delete(obj)
	if ts.isObject(obj) then ts.callobj(obj, "delete") end
end

function ts.getSimTime()
	return tonumber(ts.call("getSimTime"))
end

function ts.allBricks()
	local mbg = "MainBrickGroup"
	local mbgc = tonumber(ts.callobj(mbg, "getCount"))
	local bgi = 0
	local bg = ts.callobj(mbg, "getObject", bgi)
	local bgc = tonumber(ts.callobj(bg, "getCount"))
	local bricki = 0
	return function()
		if bricki >= bgc then
			repeat
				bgi = bgi + 1
				if bgi >= mbgc then return nil end
				bg = ts.callobj(mbg, "getObject", bgi)
				bgc = tonumber(ts.callobj(bg, "getCount"))
				bricki = 0
			until (bgc>0)
		end
		local brick = ts.callobj(bg, "getObject", bricki)
		bricki = bricki + 1
		return tonumber(brick)
	end
end
function ts.getBricksByName(searchName, regex)
	searchName = searchName:lower()
	local namedBricks = {}
	for brick in ts.allBricks() do
		local name = ts.callobj(brick, "getName"):lower()
		if (name ~= "") then
			name = name:gsub("^_", "")
			if
				((not regex) and name == searchName   ) or
				( regex      and name:find(searchName))
			then
				table.insert(namedBricks, tonumber(brick))
			end
		end
	end
	return namedBricks
end

function ts.allClients()
	local cg = "ClientGroup"
	local cgc = tonumber(ts.callobj(cg, "getCount"))
	local ci = 0
	return function()
		if ci >= cgc then return nil end
		local client = ts.callobj(cg, "getObject", ci)
		ci = ci + 1
		return tonumber(client)
	end
end
function ts.allPlayers()
	local ac = ts.allClients()
	return function()
		repeat
			local client = ac()
			if client==nil then return nil end
			player = tonumber(ts.getobj(client, "player"))
		until (ts.isObject(player))
		return tonumber(player)
	end
end

function ts.raycast(pos1, pos2, mask, ignore) return ts.call("containerRayCast",pos1,pos2,mask,ignore) end

ts.mask = {
	all = tonumber(ts.get("TypeMasks::All")),
	camera = tonumber(ts.get("TypeMasks::CameraObjectType")),
	corpse = tonumber(ts.get("TypeMasks::CorpseObjectType")),
	damagableItem = tonumber(ts.get("TypeMasks::DamagableItemObjectType")),
	debris = tonumber(ts.get("TypeMasks::DebrisObjectType")),
	environment = tonumber(ts.get("TypeMasks::EnvironmentObjectType")),
	explosion = tonumber(ts.get("TypeMasks::ExplosionObjectType")),
	brickAlways = tonumber(ts.get("TypeMasks::FxBrickAlwaysObjectType")),
	brick = tonumber(ts.get("TypeMasks::FxBrickObjectType")),
	gameBase = tonumber(ts.get("TypeMasks::GameBaseObjectType")),
	item = tonumber(ts.get("TypeMasks::ItemObjectType")),
	marker = tonumber(ts.get("TypeMasks::MarkerObjectType")),
	zone = tonumber(ts.get("TypeMasks::PhysicalZoneObjectType")),
	player = tonumber(ts.get("TypeMasks::PlayerObjectType")),
	projectile = tonumber(ts.get("TypeMasks::ProjectileObjectType")),
	shapeBase = tonumber(ts.get("TypeMasks::ShapeBaseObjectType")),
	static = tonumber(ts.get("TypeMasks::StaticObjectType")),
	staticRendered = tonumber(ts.get("TypeMasks::StaticRenderedObjectType")),
	staticShape = tonumber(ts.get("TypeMasks::StaticShapeObjectType")),
	staticTS = tonumber(ts.get("TypeMasks::StaticTSObjectType")),
	terrain = tonumber(ts.get("TypeMasks::TerrainObjectType")),
	trigger = tonumber(ts.get("TypeMasks::TriggerObjectType")),
	vehicleBlocker = tonumber(ts.get("TypeMasks::VehicleBlockerObjectType")),
	vehicle = tonumber(ts.get("TypeMasks::VehicleObjectType")),
	water = tonumber(ts.get("TypeMasks::WaterObjectType")),
}
ts.mask.general = ts.mask.brick + ts.mask.terrain + ts.mask.static + ts.mask.vehicle + ts.mask.player
