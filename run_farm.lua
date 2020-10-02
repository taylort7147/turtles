env = require("env")
Farm = require("farm")
turtlex = require("turtlex")

f = Farm:new(env.farm)
f:verify()

local crop = "wheat"
local blockData = turtlex.getBlockData("down")
local description = env.farm.cropDescriptions[crop]
local isHarvestable = f:isHarvestable(description, blockData)

local fuelReq = f:calculateFuelRequired()
print("Fuel required:", fuelReq)


f:farmAll()