=>
  c = {}
  c.__index = @
  c.__call = (...) =>
    _ = {}
    setmetatable _, c
    if @constructor then @.constructor _, ...
    return _
  setmetatable c, c
  return c
