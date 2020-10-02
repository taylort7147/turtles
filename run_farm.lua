env = require("env")
Farm = require("farm")
turtlex = require("turtlex")

f = Farm:new(env.farm)
f:verify()

local crop = "wheat"
local blockData = turtlex.getBlockData("down")
local description = env.farm.cropDescriptions[crop]
local isHarvestable = f:isHarvestable(description, blockData)

print("Is harvestable ["..crop.."]:", isHarvestable)

-- local slot = f:selectSeeds(description)
-- local itemName = description.seeds.name
-- print("First slot containing ["..itemName.."] is", slot)

local fuelReq = f:calculateFuelRequired()
print("Fuel required:", fuelReq)


f:farmAll()