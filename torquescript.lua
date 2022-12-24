ts.eval("function luaprojecitle(%pos,%datablock) {%p = new projectile() {datablock= %datablock; initialposition = %pos;};  missionCleanup.add(%p); %p.explode();}")
ts.eval("function luaitem(%obj,%datablock) {%item = new item() {datablock= %datablock; position = %obj.getHackPosition(); dropped = 1; canPickup = 1; client = %obj.client; minigame = getMinigameFromObject(%obj);}; missionCleanup.add(%loot); return %item;}")

ts.eval("function getcallobject(%obj,%var){eval(\"return \" @ %obj @ \".\" @ %var @ \";\");}")
	
function ts.getposition(obj) return ts.callobj(obj, "getposition") end

function ts.isobject(obj)
	if ts.call("isobject", obj) == "1" then return true
		else return false
	end
end

function ts.sched(time, obj, func, ...)
    ts.call("schedule", time, obj, func, ...)
end

function ts.schednoquota(time, obj, func, ...)
    ts.call("schedulenoquota", time, obj, func, ...)
end

function ts.objsched(obj, time, func, ...)
    ts.callobj(obj, "schedule", time, func, ...)
end

function ts.objschednoquota(obj, time, func, ...)
    ts.callobj(obj, "schedulenoquota", time, func, ...)
end

function ts.getstate(obj)
	if ts.isobject(obj) then return ts.callobj(obj,"getstate") end
end

function ts.minigamecandamage(objA,objB)
	if ts.isobject(objA) and ts.isobject(objB) then return ts.call("minigameCanDamage",objA,objB) end
end

function ts.getclassname(obj)
	if ts.isobject(obj) then return ts.callobj(obj,"getclassname") end
end

function ts.talk(string) return ts.call("talk",string) end

function ts.getcallobj(obj,var)
	return ts.call("getcallobject",obj,var)
end

function ts.delete(obj)
	if ts.isobject(obj) then ts.callobj(obj, "delete") end
end

function ts.getsimtime()
	return tonumber(ts.call("getsimtime"))
end

function ts.allbricks()
	local mbg = "mainbrickgroup"
	local mbgc = tonumber(ts.callobj(mbg, "getcount"))
	local bgi = 0
	local bg = ts.callobj(mbg, "getobject", bgi)
	local bgc = tonumber(ts.callobj(bg, "getcount"))
	local bricki = 0
	return function()
		if bricki >= bgc then
			repeat
				bgi = bgi + 1
				if bgi >= mbgc then return nil end
				bg = ts.callobj(mbg, "getobject", bgi)
				bgc = tonumber(ts.callobj(bg, "getcount"))
				bricki = 0
			until (bgc>0)
		end
		local brick = ts.callobj(bg, "getobject", bricki)
		bricki = bricki + 1
		return tonumber(brick)
	end
end
function ts.getbricksbyname(searchname, regex)
	searchname = searchname:lower()
	local namedbricks = {}
	for brick in ts.allbricks() do
		local name = ts.callobj(brick, "getname"):lower()
		if (name ~= "") then
			name = name:gsub("^_", "")
			if
				((not regex) and name == searchname   ) or
				( regex      and name:find(searchname))
			then
				table.insert(namedbricks, tonumber(brick))
			end
		end
	end
	return namedbricks
end

function ts.allclients()
	local cg = "clientgroup"
	local cgc = tonumber(ts.callobj(cg, "getcount"))
	local ci = 0
	return function()
		if ci >= cgc then return nil end
		local client = ts.callobj(cg, "getobject", ci)
		ci = ci + 1
		return tonumber(client)
	end
end
function ts.allplayers()
	local ac = ts.allclients()
	return function()
		repeat
			local client = ac()
			if client==nil then return nil end
			player = tonumber(ts.getobj(client, "player"))
		until (ts.isobject(player))
		return tonumber(player)
	end
end

function ts.raycast(pos1, pos2, mask, ignore) return ts.call("containerRayCast",pos1,pos2,mask,ignore) end

ts.mask = 
{
	all = tonumber(ts.get("TypeMasks::All")),
	camera = tonumber(ts.get("TypeMasks::CameraObjectType")),
	corpse = tonumber(ts.get("TypeMasks::CorpseObjectType")),
	damagableItem = tonumber(ts.get("TypeMasks::DamagableItemObjectType")),
	debris = tonumber(ts.get("TypeMasks::DebrisObjectType")),
	environment = tonumber(ts.get("TypeMasks::EnvironmentObjectType")),
	explosion = tonumber(ts.get("TypeMasks::ExplosionObjectType")),
	brickalways = tonumber(ts.get("TypeMasks::FxBrickAlwaysObjectType")),
	brick = tonumber(ts.get("TypeMasks::FxBrickObjectType")),
	gamebase = tonumber(ts.get("TypeMasks::GameBaseObjectType")),
	item = tonumber(ts.get("TypeMasks::ItemObjectType")),
	marker = tonumber(ts.get("TypeMasks::MarkerObjectType")),
	zone = tonumber(ts.get("TypeMasks::PhysicalZoneObjectType")),
	player = tonumber(ts.get("TypeMasks::PlayerObjectType")),
	projectile = tonumber(ts.get("TypeMasks::ProjectileObjectType")),
	shapeBase = tonumber(ts.get("TypeMasks::ShapeBaseObjectType")),
	static = tonumber(ts.get("TypeMasks::StaticObjectType")),
	staticrendered = tonumber(ts.get("TypeMasks::StaticRenderedObjectType")),
	staticshape = tonumber(ts.get("TypeMasks::StaticShapeObjectType")),
	staticts = tonumber(ts.get("TypeMasks::StaticTSObjectType")),
	terrain = tonumber(ts.get("TypeMasks::TerrainObjectType")),
	trigger = tonumber(ts.get("TypeMasks::TriggerObjectType")),
	vehicleblocker = tonumber(ts.get("TypeMasks::VehicleBlockerObjectType")),
	vehicle = tonumber(ts.get("TypeMasks::VehicleObjectType")),
	water = tonumber(ts.get("TypeMasks::WaterObjectType")),
}
ts.mask.general = ts.mask.brick + ts.mask.terrain + ts.mask.static + ts.mask.vehicle + ts.mask.player
ts.mask.obstruction = ts.mask.brick + ts.mask.terrain + ts.mask.static + ts.mask.vehicle
