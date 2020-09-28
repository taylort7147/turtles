----------------------
-- Static functions --
----------------------

function split(str, sep)
  sep = sep or "%s"
  if str == "" then return {} end
  local t = {}
  for m in string.gmatch(str, "([^"..sep.."]+)") do
    table.insert(t, m)
  end
  return t
end

function find(t, value)
  if type(t) ~= "table" or value == nil then return false end
  local i, v
  for k, v in pairs(t) do
    if v == value then return k end
  end
end

function contains(t, value)
  return find(t, value) ~= nil
end

function copy(x)
  if type(x) == "table" then
    local c = {}
    for k, v in pairs(x) do
      c[k] = v
    end
    return c
  else
    return
  end
end

function removeByValue(t, value)
  local key = find(t, value)
  if key then return table.remove(t, key) end
end
