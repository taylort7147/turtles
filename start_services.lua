EventManager = require("eventmanager")
RelayService = require("services/relay2")

function cb1(event, p1)
  print("cb1(", p1, ")")
end

function cb2(event, p1, p2)
  print("cb2(", p1, ", ", p2, ")")
end

em = EventManager.new()
em:subscribe("event1", cb1)
em:subscribe("event1", cb2)
em:subscribe(EventManager.events.serviceEnable, RelayService.onServiceEnable)
em:subscribe("redstone", RelayService.onRedstone)
em:subscribe("rednet_message", RelayService.onRednetMessage)
em:subscribe(RelayService.events.relay, RelayService.onRelay)



function sendEvents()
  os.sleep(0.3)
  os.queueEvent("event1", 1, 10)
  os.sleep(0.5)
  em:unsubscribe("event1", cb1)
  os.sleep(0.5)
  os.queueEvent("event1", 2, 20)
end

parallel.waitForAll(
  function() em:start() end,
  sendEvents
)


