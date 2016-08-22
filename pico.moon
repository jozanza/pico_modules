{
  _: {}
  action: (name, options) =>
    { :mutate, :reduce, :access } = options
    _ = {}
    setmetatable(_, {
      __call: (state) =>
        mutate state, reduce access state
    })
    @_[name] = _
  init: (state) =>
    actions = @_
    @store = {
      bind: (f) => -> f @
      call: (f) => -> f state
      when: (f, g) => if f state then g!
    }
    setmetatable(@store, {
      __call: (a, b, c, d) ->
        actions[b] state
    })
  update: (f) =>
    export _update = @store\bind f
  draw: (f) =>
    export _draw = @store\call f
}
