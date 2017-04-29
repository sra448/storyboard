{ connect } = require \react-redux
{ DOM } = require \react
{ div, textarea, button } = DOM


node = ({ id, content, on-change-text, on-add-child }) ->
  div { class-name: "node", style: { top: content.y, left: content.x } },
    textarea { value: content.text, on-change: on-change-text id }
    button { on-click: on-add-child id }, "+"


nodes = ({ graph, on-change-text, on-add-child }) ->
  div { class-name: "nodes" },
    graph.nodes().map (id) ->
      content = graph.node id
      node { key: id, id, content, on-change-text, on-add-child }


editor = ({ graph, on-change-text, on-reset-editor, on-add-child }) ->
  div { class-name: "editor" },
    button { on-click: on-reset-editor }, "reset editor"
    nodes { current-node: 0, graph, on-change-text, on-add-child }




map-state-to-props = ({ graph, foo }) ->
  { graph, foo }


map-dispatch-to-props = (dispatch) ->
  on-change-text: (id) -> ({ target }) -> dispatch { type: \CHANGE_NODE_TEXT, text: target.value, id }
  on-add-child: (id) -> -> dispatch { type: \ADD_CHILD_NODE, id }
  on-reset-editor: -> dispatch { type: \RESET_EDITOR }


module.exports = editor |> connect map-state-to-props, map-dispatch-to-props
