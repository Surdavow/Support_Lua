function math.clamp(value,min,max)
    return math.min(math.max(value,min),max)
end

function strToTable(s)
    local tuple = {}
    local i = 1
    for w in string.gmatch(s, "%S+") do
        tuple[i] = w
        i = i + 1
    end
    return tuple
end

function VectorAdd(str_one, str_two)
    local a = strToTable(str_one)
    local b = strToTable(str_two)
    return tostring(a[1] + b[1]) .. ' ' .. tostring(a[2] + b[2]) .. ' ' .. tostring(a[3] + b[3])
end

function VectorSub(str_one, str_two)
    local a = strToTable(str_one)
    local b = strToTable(str_two)
    return tostring(a[1] - b[1]) .. ' ' .. tostring(a[2] - b[2]) .. ' ' .. tostring(a[3] - b[3])
end

function VectorScale(str, f)
    local a = strToTable(str)
    return tostring(a[1] * f) .. ' ' .. tostring(a[2] * f) .. ' ' .. tostring(a[3] * f)
end

function VectorLength(str)
    local a = strToTable(str)
    return tostring(math.sqrt(a[1] ^ 2 + a[2] ^ 2 + a[3] ^ 2))
end

function VectorNormalize(str)
    local l = tonumber(VectorLength(str))
    return VectorScale(str, 1 / l)
end

function VectorDot(str_one, str_two)
    local a = strToTable(str_one)
    local b = strToTable(str_two)
    return tostring(a[1] * b[1] + a[2] * b[2] + a[3] * b[3])
end

function VectorDist(str_one, str_two)
    return VectorLength(VectorSub(str_one, str_two))
end

function VectorCross(str_one, str_two)
    local a = strToTable(str_one)
    local b = strToTable(str_two)
    return tostring(a[2] * b[3] - a[3] * b[2]) .. ' ' .. tostring(a[3] * b[1] - a[1] * b[3]) .. ' ' .. tostring(a[1] * b[2] - a[2] * b[1])
end

--- Evaluates ``term``, matching the expression's value to the ``cases`` clause, and executes the statements associated with the case.
---
--- To do not execute other cases, return the string 'break'
--- ```lua
--- switch(term, {
---     ['case'] = function()
---         -- ...
---         return "break"
---     end,
---     default = function() -- optional
---         -- ...
---     end
--- })
--- ```
---@param term any
---@param cases table
local function switch(term, cases)
    assert(type(cases) == "table", "bad argument #1 to 'switch': table expected, got "..type(cases))
    local gotoDefault = true

    -- in string/boolean cases
    for value, case in pairs(cases) do
        assert(type(case) == "function", "case "..tostring(case).." is not a function")
        if term == value then
            gotoDefault = false

            local exec = case()

            if exec == "break" then
                break
            end
        end
    end

    if cases.default ~= nil and type(cases.default) == "function" and gotoDefault == true then
        cases.default()
    end
end

local grade = 'A'

switch(grade, {
    ['A'] = function ()
        print("awesome!")
    end,
    ['B'] = function ()
        print("not bad!")
    end,
    ['C'] = function ()
        print('crap.')
    end
})
