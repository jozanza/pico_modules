-- :: * -> str
stringify = (x, _ = '') ->
  tx = type x
  if 'number' == tx
    return x
  if 'string' == tx
    return '\''..x..'\''
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

-- memoizes return from args
-- :: func -> * -> *
memo = (f) ->
  cache = {}
  setmetatable cache, { __mode: 'kv' }
  (...) ->
    k = stringify {...}
    if cache[k]
      return cache[k]
    else
      x = f ...
      cache[k] = x
      return x

-- converts a table to args
-- :: *... -> *...
unpack = (xs, i = 1) ->
  g = xs[i]
  if i > #xs then return
  return g, (unpack xs, i + 1)

-- memoized version of unpack
munpack = memo unpack

-- runs a coro then calls cb
-- :: func, func -> func -> *
corun = (f, cb) ->
  coro = nil
  (...) ->
    if not coro
      args = {...}
      coro = cocreate -> f unpack args
    if costatus coro
      coresume coro
    else
      coro = nil
      if cb then return cb ...
    return ...

-- does nothing
-- :: () -> nil
noop = ->

-- returns given value
-- :: *... -> *...
identity = (...) -> ...

-- returns fn that returns given value
-- :: x -> * -> x
value = (x) -> -> x

is_lt = (a) -> (b) ->
  a < b

is_lteq = (a) -> (b) ->
  a <= b

is_gt = (a) -> (b) ->
  a > b

is_gteq = (a) -> (b) ->
  a >= b

is_eq = (a) -> (b) ->
  a == b

equals = (a, b) -> (...) ->
  a ... == b ...

-- returns true
-- nil -> true
_true_ = value true

-- returns false
-- nil -> false
_false_ = value false

-- composes each func rtl
-- :: func[] -> * -> *
seq = (fs) -> (x) ->
  for f in *fs do x = f x
  return x

-- applies args to each func
-- :: func[] -> * -> nil
apply_each = (fs) -> (...) ->
  for f in *fs do f ...

-- applies args to a func
-- :: func, * -> () -> *
apply = (f, ...) ->
  args = {...}
  () -> f munpack args

-- calls a method of an object
-- :: str -> {} -> *
call = (k, ...) ->
  args = {...}
  => @[k] @, munpack args

-- composable if/else
-- :: func... -> * -> *
iff = (a, b, c = identity) ->
  (...) -> if a! then b ... else c ...

-- composable switch
-- :: func[] -> * -> *
cond = (cases) -> (...) ->
  for {yepnope, next} in *cases
    if yepnope ...
      return next ...
  return ...

-- :: func -> x -> x
tap = (f) -> (...) ->
  f ...
  return ...

-- :: str|func -> x -> x
trace = (f) ->
  if 'function' == type f
    return tap f
  tap -> printh_table f

incr = (x) ->
  if x < 32767
    x += 1
  else
    x = 0
  return x

decr = (x) ->
  if x > -32767
    x -= 1
  else
    x = 0
  return x

-- :: str -> {} -> *
prop = (k) -> (o) ->
  o[k]

prop_eq = (k) -> (x) -> tap seq {
  prop k
  is_eq x
}

-- :: str[] -> {} -> *
deep_prop = (ks) -> (o) ->
  x = o[ks[1]]
  for k in *ks[2,] do x = x[k]
  return x

-- creates a class-like object
implements = (x) ->
  x.__index = x
  setmetatable({
    __init: x.constructor or (->),
    __base: x
  }, {
    __index: x,
    __call: (...) =>
      cls = setmetatable {}, x
      @.__init cls, ...
      return cls
  })

-- mutation-effect pattern
mfx = (a, b) =>
  (-> a @), (-> b @)

return {
  :corun
  :noop
  :identity
  :value
  :is_lt
  :is_lteq
  :is_gt
  :is_gteq
  :is_eq
  :equals
  :_true_
  :_false_
  :seq
  :apply_each
  :apply
  :call
  :iff
  :cond
  :memo
  :unpack
  :munpack
  :tap
  :trace
  :stringify
  :incr
  :decr
  :prop
  :prop_eq
  :deep_prop
  :implements
  :mfx
 }
