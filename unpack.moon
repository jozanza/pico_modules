unpack = (xs, i = 1) ->
  g = xs[i]
  if i > #xs then return
  return g, (unpack xs, i + 1)

return unpack
