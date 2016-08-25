(x, _ = '') ->
  tx = type x
  if 'number' == tx
    return x
  if 'string' == tx
    return '\"'..x..'\"'
  if 'nil' == tx
    return 'nil'
  if 'function' == tx
    return '[function]'
  if 'boolean' == tx
    return x and 'true' or 'false'
  s = '{'
  __ = _..'  '
  for k,v in pairs x
    k = stringify k
    v = stringify v, __
    s = s..'\n'..__..'['..k..']= '..v
  s = s..'\n'.._..'} '
  return s
