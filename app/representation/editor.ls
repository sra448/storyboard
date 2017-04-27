{ connect } = require \react-redux
{ DOM } = require \react
{ div, textarea, button } = DOM


node = ({ id, value, class-name, on-change-text, on-add-child })->
  class-name = ["node", class-name].join " "
  div { class-name },
    textarea { value, on-change: on-change-text id }
    button { on-click: on-add-child id }, "+"


nodes = ({ graph, current-node, on-change-text, on-add-child }) ->
  value = graph.node current-node
  edges = graph.out-edges current-node
  parent = (graph.in-edges current-node)[0]?.v
  is-him = if parent then (graph.out-edges parent).length == 1 else true
  class-name = "him" if is-him

  if edges.length == 0
    node { id: current-node, value, class-name, on-change-text, on-add-child }
  else
    div {},
      node { id: current-node, value, class-name, on-change-text, on-add-child }
      div { class-name: "children" },
        edges.map (n) ->
          nodes { key: n.w, current-node: n.w, graph, on-change-text, on-add-child }


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
