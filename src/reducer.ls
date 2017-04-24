{ Graph } = require \graphlib

initial-state =
  foo: 1 # this is a hack, since the graph is mutated :/
  current-node: 1
  graph: (new Graph).set-node 1, "hello? can you help me?"


change-current-node-text = (state, { target }) ->
  { ...state, foo: state.foo + 1, graph: state.graph.set-node 1, target.value }


module.exports = (state = initial-state, action) ->
  switch action.type
    case \CHANGE_CURRENT_NODE then change-current-node-text state, action.text
    default state
