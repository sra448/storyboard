{ connect } = require \react-redux
{ DOM, create-element } = require \react
{ div, textarea, button, svg, line, defs, path, g } = DOM
Draggable = require \react-draggable


node = ({ graph, id, content, on-change-text, on-add-child }) ->
  who = if (graph.out-edges id).length > 1 then "him" else "us"
  div { class-name: "node #{who}" },
    textarea { value: content.text, on-change: on-change-text id }
    button { id: id, class-name: "new-edge", on-click: on-add-child id }, "+"


nodes = ({ graph, on-change-text, on-change-position, on-add-child }) ->
  div { class-name: "nodes" },
    graph.nodes().map (id) ->
      content = graph.node id
      position = { x: content.x, y: content.y }
      create-element Draggable, { position, grid: [20, 20], on-drag: on-change-position id },
        node { key: id, id, graph, content, on-change-text, on-add-child }


edge = ({ graph, v, w }) ->
  parent = graph.node v
  child = graph.node w
  x1 = parent.x + 50
  y1 = parent.y + 60
  x2 = child.x + 50
  y2 = child.y

  if y2 <= y1
    width = x2 - x1
    height = y1 - y2
    path { d: "M#{x1} #{y1} v20 h#{if x2 < x1 then 70 else -70} v-#{height + 40} h#{x2 - x1 + if x2 < x1 then -70 else 70} v20", marker-end: "url(\#arrow)" }
  else
    line { key: "#{v}:#{w}", marker-end: "url(\#arrow)", x1, y1, x2, y2: y2 - 2 }


edges = ({ graph, temp-edge }) ->
  marker-options =
    id: \arrow
    marker-width: 10
    marker-height: 10
    ref-x: 15
    ref-y: 3
    orient: "auto"
    marker-units: "strokeWidth"

  svg { width: "100%", height: "100%" },
    defs {},
      create-element \marker, { ...marker-options },
        path { d: "M0,0 L0,6 L9,3 z", fill: "black" }
    line temp-edge if temp-edge
    graph.edges().map ({ v, w }) ->
      edge { graph, v, w }


editor = ({ graph, temp-edge, on-reset-editor, on-change-text, on-change-position, on-add-child }) ->
  div { class-name: "editor" },
    button { on-click: on-reset-editor }, "reset editor"
    nodes { graph, on-change-text, on-change-position, on-add-child }
    edges { graph, temp-edge }




map-state-to-props = ({ graph, temp-edge, foo }) ->
  { graph, temp-edge, foo }


map-dispatch-to-props = (dispatch) ->
  on-change-text: (id) -> ({ target }) -> dispatch { type: \CHANGE_NODE_TEXT, text: target.value, id }
  on-change-position: (id) -> (e, { x, y }) ->
    dispatch { type: \CHANGE_NODE_POSITION, id, x: (Math.round x / 20) * 20, y: (Math.round y / 20) * 20 }
  on-add-child: (id) -> -> dispatch { type: \ADD_CHILD_NODE, id }
  on-reset-editor: -> dispatch { type: \RESET_EDITOR }


module.exports = editor |> connect map-state-to-props, map-dispatch-to-props
