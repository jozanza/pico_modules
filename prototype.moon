=>
  c = {}
  c.__index = @
  c.__call = (...) =>
    _ = {}
    setmetatable _, c
    if @constructor then @constructor ...
    return _
  setmetatable c, c
