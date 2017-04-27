{ Graph } = require \graphlib

initial-state =
  foo: 1 # this is a hack, since the graph is being mutated :/
  current-node: 0
  history: [{ who: \him, text: "hello?" }]
  graph: (new Graph).set-node 0, "hello?"


id-generator = (id = 1) -> -> id++


get-id = id-generator()


change-node-text = (state, id, text) ->
  state.graph.set-node id, text
  { ...state, foo: state.foo + 1 }


add-child-node = (state, parent-id) ->
  id = get-id()
  state.graph.set-node id, ""
  state.graph.set-edge parent-id, id
  { ...state, foo: state.foo + 1 }


choose-next-node = (state, id) ->
  answer = (state.graph.out-edges id)?[0] || {}
  me = { who: \me, text: state.graph.node id }
  him = { who: \him, text: state.graph.node answer.w }
  history = [...state.history, me, him]
  { ...state, history, current-node: answer.w }


module.exports = (state = initial-state, action) ->
  console.log "->", action.type, action
  switch action.type
    case \CHANGE_NODE_TEXT then change-node-text state, action.id, action.text
    case \ADD_CHILD_NODE then add-child-node state, action.id
    case \CHOOSE_NEXT_NODE then choose-next-node state, action.id
    default state
