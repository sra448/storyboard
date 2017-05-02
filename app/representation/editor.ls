{ connect } = require \react-redux
{ DOM, create-element } = require \react
{ div, textarea, button, svg, line } = DOM
Draggable = require \react-draggable


node = ({ id, content, on-change-text, on-add-child }) ->
  div { class-name: "node" },
    textarea { value: content.text, on-change: on-change-text id }
    button { id: id, class-name: "new-edge", on-click: on-add-child id }, "+"


nodes = ({ graph, on-change-text, on-change-position, on-add-child }) ->
  div { class-name: "nodes" },
    graph.nodes().map (id) ->
      content = graph.node id
      position = { x: content.x, y: content.y }
      create-element Draggable, { position, grid: [20, 20], on-drag: on-change-position id },
        node { key: id, id, content, on-change-text, on-add-child }


edges = ({ graph, temp-edge }) ->
  svg { width: "100%", height: "100%" },
    line temp-edge if temp-edge
    graph.edges().map ({ v, w }) ->
      parent = graph.node v
      child = graph.node w
      line { key: "#{v}:#{w}", x1: parent.x + 50, y1: parent.y + 60, x2: child.x + 50, y2: child.y }


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
