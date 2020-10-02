local turtlex = {}

function turtlex.repeatFunc(amount, func, ...)
  amount = amount or 1
  if amount < 0 then
    error("amount must be >= 0")
  end
  for i = 1, amount do
    func(unpack(arg))
  end
end


-- Movement functions

function turtlex.turnLeft(amount)
  turtlex.repeatFunc(amount, turtle.turnLeft)  
end

function turtlex.turnRight(amount)
  turtlex.repeatFunc(amount, turtle.turnRight)
end

function turtlex.turnAround()
  turtlex.turnLeft(2)
end

function turtlex.getTurnFunction(direction)
  if direction == "right" then
    return turtlex.turnRight
  elseif direction == "left" then
    return turtlex.turnLeft
  end
end

function turtlex.getOppositeDirection(direction)
  if direction == "left" then return "right"
  elseif direction == "right" then return "left"
  elseif direction == "up" then return "down"
  elseif direction == "down" then return "up"
  elseif direction == "forward" then return "back"
  elseif direction == "back" then return "forward"
  end
end

function turtlex.turn(direction, amount)
  turtlex.getTurnFunction(direction)(amount)
end

function turtlex.turnOpposite(direction)
  turtlex.turn(turtlex.getOppositeDirection(direction))
end

function turtlex.forward(amount)
  turtlex.repeatFunc(amount, turtle.forward)
end

function turtlex.back(amount)
  turtlex.repeatFunc(amount, turtle.back)
end

function turtlex.up(amount)
  turtlex.repeatFunc(amount, turtle.up)
end

function turtlex.down(amount)
  turtlex.repeatFunc(amount, turtle.down)
end

-- Dig functions

function turtlex.getDigFunction(direction)
  if direction == "up" then
    return turtle.digUp
  elseif direction == "down" then
    return turtle.digDown
  elseif direction == nil or direction == "forward" then
    return turtle.digDown
  end
end

function turtlex.dig(direction)
  local func = turtlex.getDigFunction(direction)
  assert(func)
  func()
end

-- Suck functions

function turtlex.getSuckFunction(direction)
  if direction == "up" then
    return turtle.suckUp
  elseif direction == "down" then
    return turtle.suckDown
  elseif direction == nil or direction == "forward" then
    return turtle.suck
  end
end

function turtlex.suck(direction)
  local func = turtlex.getSuckFunction(direction)
  assert(func)
  func()
end

-- Place functions

function turtlex.getPlaceFunction(direction)
  if direction == "up" then
    return turtle.placeUp
  elseif direction == "down" then
    return turtle.placeDown
  elseif direction == nil or direction == "forward" then
    return turtle.place
  end
end

function turtlex.place(direction)
  local func = turtlex.getPlaceFunction(direction)
  assert(func)
  func()
end

-- Drop functions

function turtlex.getDropFunction(direction)
  if direction == "up" then
    return turtle.dropUp
  elseif direction == "down" then
    return turtle.dropDown
  elseif direction == nil or direction == "forward" then
    return turtle.drop
  end
end

function turtlex.drop(direction, ...)
  local func = turtlex.getDropFunction(direction)
  assert(func)
  func(...)
end


-- Inspection functions

function turtlex.getInspectFunction(direction)
  if direction == "down" then 
    return turtle.inspectDown
  elseif direction == "up" then 
    return turtle.inspectUp
  elseif direction == "forward" or direction == nil then 
    return turtle.inspect
  end
end

function turtlex.getBlockData(direction)
  local inspectFunc = turtlex.getInspectFunction(direction)
  assert(inspectFunc)
  local success, data = inspectFunc()
  if success then
    return data
  end
end

function turtlex.getItemData(slot)
  slot = slot or turtle.getSelectedSlot()
  return turtle.getItemDetail(slot)
end

function turtlex.hasTag(data, tag)
  if data and data.tags then
    return data.tags[tag] ~= nil
  end
  return false
end


-- Inventory functions

function turtlex.findItem(name, startSlot)
  startSlot = startSlot or turtle.getSelectedSlot()
  for i = 1, 16 do
    local slot = (startSlot - 2 + i) % 16 + 1
    local data = turtlex.getItemData(slot)
    if data and ((not name) or (data.name == name)) then
      return slot
    end
  end
end


function turtlex.selectItem(name, startSlot)
  local slot = turtlex.findItem(name, startSlot)
  if slot then
    turtle.select(slot)
  end
  return slot
end


function turtlex.getTotalItemCount(name)
  local total = 0
  for slot = 1, 16 do
    local data = turtlex.getItemData(slot)
    if data and data.name == name then
      total = total + turtle.getItemCount(slot)
    end
  end
  return total
end


function turtlex.consolidate()
  local i, slotA, slotB
  for i = 1, 16 do
    local countI = turtle.getItemCount(i)
    slotA = turtlex.findItem(nil, i)
    if slotA >= i then
      while true do
        local remainingA = turtle.getItemSpace(slotA)
        -- Exit condition 1
        if remainingA == 0 then 
          break 
        end

        local data = turtlex.getItemData(slotA)
        assert(data)
        slotB = turtlex.findItem(data.name, slotA + 1)
        
        -- Exit condition 2
        if (slotB == nil) or (slotB <= slotA) then
          break
        end

        local countB = turtle.getItemCount(slotB)
        local itemsToTransfer = math.min(remainingA, countB)
        assert(itemsToTransfer > 0)

        -- Move items
        local existingSlot = turtle.getSelectedSlot()
        turtle.select(slotB)
        local success = turtle.transferTo(slotA, itemsToTransfer)
        turtle.select(existingSlot)

        -- Exit condition 3
        if not success then
          break
        end


      end -- Swap loop
    
    elseif countI and slotA > i then -- slotA ~= i, but contains something. Move it to i.
      local existingSlot = turtle.getSelectedSlot()
      turtle.select(slotA)
      turtle.transferTo(i)
      turtle.select(existingSlot)
    end
  end-- Slot loop

end


function turtlex.getNextEmptySlot(startSlot)
  startSlot = startSlot or turtle.getSelectedSlot()  
  for i = 1, 16 do
    local slot = (startSlot - 2 + i) % 16 + 1
    local data = turtlex.getItemData(slot)
    if not data then
      return slot
    end
  end
end


function turtlex.getEmptySlots()
  emptySlots = {}
  for slot = 1, 16 do
    if turtle.getItemCount(slot) == 0 then
      table.insert(emptySlots, slot)
    end
  end
  return emptySlots
end


function turtlex.emptyInventory(direction)
  local existingSlot = turtle.getSelectedSlot()
  for slot = 1, 16 do
    turtle.select(slot)
    turtlex.drop(direction)
  end
  turtle.select(existingSlot)
end

return turtlex
