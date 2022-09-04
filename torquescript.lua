ts.eval("function LuaProjecitle(%pos,%datablock) {%p = new projectile() {datablock= %datablock; initialPosition = %pos;}; %p.explode();}")
ts.eval("function GetCallObject(%obj,%var){eval(\"return \" @ %obj @ \".\" @ %var @ \";\");}")
	
function ts.getPosition(obj) return vector(ts.callobj(obj, "getPosition")) end

function ts.isObject(obj)
	if ts.call("isObject", obj) == "1" then return true
		else return false
	end
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
	brick = tonumber(ts.get("TypeMasks::FxBrickObjectType")),
	brickAlways = tonumber(ts.get("TypeMasks::FxBrickAlwaysObjectType")),
	player = tonumber(ts.get("TypeMasks::PlayerObjectType")),
	terrain = tonumber(ts.get("TypeMasks::TerrainObjectType")),
	static = tonumber(ts.get("TypeMasks::StaticObjectType")),
	vehicle = tonumber(ts.get("TypeMasks::VehicleObjectType")),
}
ts.mask.general = ts.mask.brick + ts.mask.terrain + ts.mask.static + ts.mask.vehicle + ts.mask.player
