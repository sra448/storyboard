{ Graph, json } = require \graphlib
guid = require \guid


save-data = (state) ->
  graph = json.write state.graph
  local-storage.set-item "state", JSON.stringify { ...state, graph }


retrieve-data = ->
  state = JSON.parse local-storage.get-item "state"
  state && { ...state, graph: json.read state.graph }


reset-player = (state) ->
  history = [{ who: \him, text: state.graph.node 0 }]
  { ...state, history, current-node: 0 }

reset-editor = (state) ->
  history = [{ who: \him, text: "hello?" }]
  { ...state, history, graph: (new Graph).set-node 0, "hello?" }


change-node-text = (state, id, text) ->
  state.graph.set-node id, text
  { ...state, foo: state.foo + 1 }


add-child-node = (state, parent-id) ->
  id = guid.create().value
  state.graph.set-node id, ""
  state.graph.set-edge parent-id, id
  { ...state, foo: state.foo + 1 }


choose-next-node = (state, id) ->
  answer = (state.graph.out-edges id)?[0] || {}
  me = { who: \me, text: state.graph.node id }
  him = { who: \him, text: state.graph.node answer.w }
  history = [...state.history, me, him]
  { ...state, history, current-node: answer.w }



initial-state = retrieve-data() || do
  foo: 1 # this is a hack, since the graph is being mutated :/
  current-node: 0
  history: [{ who: \him, text: "hello?" }]
  graph: (new Graph).set-node 0, "hello?"


module.exports = (state = initial-state, action) ->
  console.log "->", action.type, action
  new-state = switch action.type
    case \RESET_PLAYER then reset-player state
    case \RESET_EDITOR then reset-editor state
    case \CHANGE_NODE_TEXT then change-node-text state, action.id, action.text
    case \ADD_CHILD_NODE then add-child-node state, action.id
    case \CHOOSE_NEXT_NODE then choose-next-node state, action.id
    default state
  save-data new-state
  new-state
