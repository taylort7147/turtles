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
    minEmptySlots = 5,
    minSeeds = 32,
    layout = {
      "wheat",
      "carrots",
      "hemp",
      "wheat",
      "carrots",
      "hemp",
      "wheat",
      "carrots",
      "beetroots",
      "wheat",
      "carrots",
      "potatoes",
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
            function(data) return data.state.age == 7 end
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
            function(data) return data.state.age == 7 end
          }
        },
        seeds = {
          name = "minecraft:carrot"
        }
      },
      ["hemp"] = {
        harvestable = true,
        block = {
          name = "immersiveengineering:hemp",
          requirements = {
            function(data) return data.state.growth == "bottom4" end
          }
        },
        seeds = {
          name = "immersiveengineering:seed"
        }
      },
      ["beetroots"] = {
        harvestable = true,
        block = {
          name = "minecraft:beetroots",
          requirements = {
            function(data) return data.state.age >= 3 end
          }
        },
        seeds = {
          name = "minecraft:beetroot_seeds"
        }
      },
      ["potatoes"] = {
        harvestable = true,
        block = {
          name = "minecraft:potatoes",
          requirements = {
            function(data) return data.state.age >= 7 end
          }
        },
        seeds = {
          name = "minecraft:potato"
        }
      }
    } -- cropDescriptions
  } -- farm

}

return env