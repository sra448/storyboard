{ Graph, json } = require \graphlib
guid = require \guid


save-data = (state) ->
  graph = json.write state.graph
  local-storage.set-item "state", JSON.stringify { ...state, graph }


retrieve-data = ->
  state = JSON.parse local-storage.get-item "state"
  state && { ...state, graph: json.read state.graph }


reset-player = (state) ->
  history = [{ who: \him, id: "0" }]
  { ...state, history, current-node: "0" }


reset-editor = (state) ->
  history = [{ who: \him, id: "hello?" }]
  { ...state, history, graph: (new Graph).set-node "0", { who: \him, id: "hello?" } }


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
  me = { who: \me, id: id }
  him = { who: \him, id: answer.w }
  history = [...state.history, me, him]
  { ...state, history, current-node: answer.w }


add-temp-edge = (state, id) ->
  parent = state.graph.node id
  { ...state, temp-edge: { id, x1: parent.x + 50, y1: parent.y + 60, x2: parent.x + 50, y2: parent.y + 30 }}


change-temp-edge-position = (state, x, y) ->
  edge = state.temp-edge
  { ...state, temp-edge: { ...edge, x2: x, y2: y }}


close-temp-edge = (state) ->
  { temp-edge } = state
  nodes = state.graph.nodes().filter (id) ->
    { x, y } = state.graph.node id
    x <= temp-edge.x2 <= x + 100 && y <= temp-edge.y2 <= y + 60

  if nodes.length == 1 && nodes[0] != temp-edge.id
    state.graph.set-edge temp-edge.id, nodes[0]

  { ...state, temp-edge: undefined }



initial-state = retrieve-data() || do
  foo: 1 # this is a hack, since the graph is being mutated :/
  current-node: 0
  history: [{ who: \him, id: "0" }]
  temp-edge: undefined
  graph: (new Graph).set-node "0", { text: "hello?", x: 300, y: 50 }


module.exports = (state = initial-state, action) ->
  console.log "->", action.type, action
  new-state = switch action.type
    case \RESET_PLAYER then reset-player state
    case \RESET_EDITOR then reset-editor state
    case \CHANGE_NODE_TEXT then change-node-text state, action.id, action.text
    case \CHANGE_NODE_POSITION then change-node-position state, action.id, action.x, action.y
    case \ADD_CHILD_NODE then add-child-node state, action.id
    case \CHOOSE_NEXT_NODE then choose-next-node state, action.id
    case \ADD_TEMP_EDGE then add-temp-edge state, action.id
    case \CHANGE_TEMP_EDGE_POSITION then change-temp-edge-position state, action.x, action.y
    case \CLOSE_TEMP_EDGE then close-temp-edge state
    default state
  save-data new-state
  new-state
