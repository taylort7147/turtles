
parallel.waitForAny(
  function() shell.run("start_services") end,
  function() shell.run("shell") end
)
