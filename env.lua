env = {
  mainServer = "Computer_11",
  events = {
    ["redstone"] = {
      -- redstone callbacks
    },
    ["rednet_message"] = {
      -- rednet_message callbacks
    },
    ["command"] = {
      -- command callbacks
    }
  }, -- events

  farm = {
    direction = "left",
    length = 22,
    minEmptySlots = 3,
    minSeeds = 32,
    layout = {
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots",
      "wheat",
      "carrots"
    },
    cropDescriptions = {
      ["wheat"] = {
        harvestable = true,
        block = {
          name = "minecraft:wheat",
          requirements = {
            age = 7
          }
        },
        seeds = {
          name = "minecraft:wheat_seeds"
        }
      },
      ["carrots"] = {
        harvestable = true,
        block = {
          name = "minecraft:carrots",
          requirements = {
            age = 7
          }
        },
        seeds = {
          name = "minecraft:carrot"
        }
      }
    } -- cropDescriptions
  } -- farm

}

return env