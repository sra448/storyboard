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
  node = state.graph.node id
  state.graph.set-node id, { ...node, text }
  { ...state, foo: state.foo + 1 }


change-node-position = (state, id, x, y) ->
  node = state.graph.node id
  state.graph.set-node id, { ...node, x, y }
  { ...state, foo: state.foo + 1 }


add-child-node = (state, parent-id) ->
  id = guid.create().value
  parent = state.graph.node parent-id

  x = parent.x
  y = parent.y + 80

  state.graph.set-node id, { x, y, text: "" }
  state.graph.set-edge parent-id, id

  siblings-ids = state.graph.out-edges parent-id
  if siblings-ids.length > 0
    starting-x = x - siblings-ids.length * 120 / 2 + 60
    siblings-ids.for-each ({ w }, i) ->
      n = state.graph.node w
      state.graph.set-node w, { ...n, x: starting-x + i * 120 }

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
  graph: (new Graph).set-node 0, { text: "hello?", x: 0, y: 0 }


module.exports = (state = initial-state, action) ->
  console.log "->", action.type, action
  new-state = switch action.type
    case \RESET_PLAYER then reset-player state
    case \RESET_EDITOR then reset-editor state
    case \CHANGE_NODE_TEXT then change-node-text state, action.id, action.text
    case \CHANGE_NODE_POSITION then change-node-position state, action.id, action.x, action.y
    case \ADD_CHILD_NODE then add-child-node state, action.id
    case \CHOOSE_NEXT_NODE then choose-next-node state, action.id
    default state
  save-data new-state
  new-state
