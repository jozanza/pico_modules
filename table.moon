return {
  copy: (xs) ->
    {k,v for k,v in pairs xs}
  keys: (xs) ->
    [k for k,v in pairs xs]
  values: (xs) ->
    [v for k,v in pairs xs]
  merge: (...) ->
    {k, v for x in all {...} for k, v in pairs x}
  assign: (a, b) ->
    for k,v in pairs b
      a[k] = v
  map: (f, xs) ->
    {k, f v, k, xs for k, v in pairs xs}
  filter: (f, xs) ->
    {k, v for k, v in pairs xs when f v, k, xs}
  reduce: (f, x, xs) ->
    _x = (type(x) == 'table') and (table.copy x) or x
    for k, v in pairs xs
      _x = f _x, v, k, xs
    _x
  pretty: (x) ->
    stringify = (x, _) ->
      tx = type x
      if 'number' == tx then return x
      if 'string' == tx then return "'"..x.."'"
      if 'nil' == tx then return 'nil'
      if 'function' == tx then return '[function]'
      if 'boolean' == tx then return x and 'true' or 'false'
      s = '{'
      __ = _..'  '
      for k,v in pairs x
        k = stringify k, ''
        v = stringify v, __
        s = s..'\n'..__..'['..k..']= '..v
      s..'\n'.._..'} '
    stringify x, ''
}

