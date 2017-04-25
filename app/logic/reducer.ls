{ Graph } = require \graphlib

initial-state =
  foo: 1 # this is a hack, since the graph is being mutated :/
  graph: (new Graph).set-node 0, "hello? can you help me?"


id-generator = ->
  id = 1
  -> id++


get-id = id-generator()


change-node-text = (state, id, text) ->
  state.graph.set-node id, text
  { ...state, foo: state.foo + 1 }


add-child-node = (state, parent-id) ->
  id = get-id()
  state.graph.set-node id, ""
  state.graph.set-edge parent-id, id
  { ...state, foo: state.foo + 1 }


module.exports = (state = initial-state, action) ->
  console.log "->", action.type, action
  switch action.type
    case \CHANGE_NODE_TEXT then change-node-text state, action.id, action.text
    case \ADD_CHILD_NODE then add-child-node state, action.id
    default state
