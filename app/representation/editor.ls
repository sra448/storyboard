{ connect } = require \react-redux
{ DOM } = require \react
{ div, input, button } = DOM


node = ({ id, value, on-change-text, on-add-child })->
  div {},
    input { value, on-change: on-change-text id }
    button { on-click: on-add-child id }, "add child node"


nodes = ({ graph, current-node, on-change-text, on-add-child }) ->
  value = graph.node current-node
  edges = graph.out-edges current-node

  div {},
    node { id: current-node, value, on-change-text, on-add-child }
    if edges.length > 0
      edges.map (n) ->
        nodes { key: n.w, current-node: n.w, graph, on-change-text, on-add-child }


editor = ({ graph, on-change-text, on-add-child }) ->
  div { style: { flex: "1 1" } },
    nodes { current-node: 0, graph, on-change-text, on-add-child }




map-state-to-props = ({ graph, foo }) ->
  { graph, foo }


map-dispatch-to-props = (dispatch) ->
  on-change-text: (id) -> ({ target }) -> dispatch { type: \CHANGE_NODE_TEXT, text: target.value, id }
  on-add-child: (id) -> -> dispatch { type: \ADD_CHILD_NODE, id }


module.exports = editor |> connect map-state-to-props, map-dispatch-to-props
