local Set = require("set")
local turtlex = require("turtlex")

local Farm = {}
Farm.__index = Farm

function Farm:new(description)
  local o = {
    description = description
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function Farm:verify()
  assert(self.description)
  assert(self.description.direction == "left" or self.description.direction == "right")
  assert(self.description.layout)
  assert(self.description.cropDescriptions)
  for _, crop in ipairs(self.description.layout) do
    cropDescription = self.description.cropDescriptions[crop]
    assert(cropDescription)
  end
end


function Farm:isHarvestable(cropDescription, data)
  local expectData = cropDescription.block
  if expectData == nil then return false end
  if data == nil then return true end
  
  -- Check if it's the right type. If not, dig
  -- it up so we can plant the right type.
  if data.name ~= expectData.name then
    return true
  end

  -- Check requirements
  local requirements = expectData.requirements 
  if requirements then
    for _, req in ipairs(requirements) do
      if req(data) ~= true then
        return false
      end
    end
  end

  -- All criteria is met, it is harvestable
  return true
end


function Farm:selectSeeds(cropDescription)
  local data = cropDescription.seeds
  local name = data.name
  return turtlex.selectItem(name)
end


function Farm:calculateFuelRequired()
  local layout = self.description.layout
  local length = self.description.length
  local farmRows = #layout  
  -- Return distance
  local x = 2 * farmRows
  local y = farmRows * length
  if farmRows % 2 == 1 then
    y = y + length
  end
  local distance = x + y
  return distance
end


function Farm:tryHarvest(cropDescription)
  if not cropDescription.harvestable then
    return
  end

  local blockData = turtlex.getBlockData("down")
  if self:isHarvestable(cropDescription, blockData) then
    turtlex.dig("down")
    turtlex.suck("down")
  end
end


function Farm:tryPlant(cropDescription)
  if self:selectSeeds(cropDescription) and not turtlex.getBlockData("down") then
    turtlex.place("down")
  end
end


function Farm:getCropTypes()
  local cropTypes = Set:new()
  for _, cropType in ipairs(self.description.layout) do
    cropTypes:insert(cropType)
  end
  return cropTypes
end


function Farm:getSeedTypes()
  local cropTypes = self:getCropTypes()
  local seedTypes = Set:new()
  for cropType, _ in pairs(cropTypes) do
    seedTypes:insert(self.description.cropDescriptions[cropType].seeds.name)
  end
  return seedTypes
end

-- Empties the turtle's inventory, leaving the minimum seeds
function Farm:emptyInventory(direction)
  local seedTypes = self:getSeedTypes()
  local minSeeds = self.description.minSeeds
  local existingSlot = turtle.getSelectedSlot()

  for slot = 1, 16 do
    local data = turtlex.getItemData(slot)
    if data and seedTypes:contains(data.name) then
      local remaining = turtlex.getTotalItemCount(data.name)
      local safeToDropAmount = math.max(remaining - minSeeds, 0)
      local safeToDropAmount = math.min(safeToDropAmount, 64)
      turtle.select(slot)
      turtlex.drop(direction, safeToDropAmount)
    elseif data then
      turtle.select(slot)
      turtlex.drop(direction)
    end    
  end

  turtle.select(existingSlot)
end

-- Calls func with chest below the turtle
function Farm:doAtChest(func)
  turtlex.back()
  turtlex.down()
  local data = turtlex.getBlockData("down")
  assert(data and data.name:find("chest"))
  func()
  turtlex.up()
  turtlex.forward()
end


function Farm:farmRow(cropDescription, length)
  for i = 1, length do
    self:tryHarvest(cropDescription)
    self:tryPlant(cropDescription)
    if i < length then
      turtlex.forward()
    end
  end
end

function Farm:unload()
  self:doAtChest(
    function()
      self:emptyInventory("down")
      turtlex.consolidate()
    end
  )
end

-- Checks if there are fewer than the minimum number of empty
-- slots open, and if so returns to the chest to unload its inventory.
--
-- Preconditions:
--   Must be at the beginning of the row on the same side as the starting location
--   Must be facing the opposite direction as the starting direction
function Farm:tryUnload(rowDistance)
  local direction = self.description.direction
  if #turtlex.getEmptySlots() < self.description.minEmptySlots then
    turtlex.turn(direction)
    turtlex.forward(rowDistance - 1)
    turtlex.turn(direction)
    self:unload()
    turtlex.turn(direction)
    turtlex.forward(rowDistance - 1)
    turtlex.turn(direction)
  end
end


function Farm:farmAll()
  local length = self.description.length
  local rows = #(self.description.layout)
  self:unload()
  
  for row, crop in ipairs(self.description.layout) do
    local cropDescription = self.description.cropDescriptions[crop]
    assert(cropDescription)
    f:farmRow(cropDescription, length)
    turtlex.consolidate()
    
    -- If we have too few empty slots, return and empty inventory into chest
    if row % 2 == 0  and row ~= rows then
      self:tryUnload(row)
    end

    if row < rows then
      local direction = self.description.direction
      if row % 2 == 0 then
        direction = turtlex.getOppositeDirection(direction)
      end
      turtlex.turn(direction)
      turtlex.forward()
      turtlex.turn(direction)
    end

  end -- row loop

  -- return
  if rows % 2 == 0 then
    turtlex.turn(self.description.direction)
  else
    turtlex.back(length - 1)
    turtlex.turnOpposite(self.description.direction)
  end
  turtlex.forward(rows - 1)
  turtlex.turn(self.description.direction)
  self:unload()
  print("Done")
end


return Farm