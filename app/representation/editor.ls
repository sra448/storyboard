{ connect } = require \react-redux
{ DOM } = require \react
{ div, input, button } = DOM


node = ({ graph, current-value, on-change })->
  current-value = graph.node 1
  div {},
    input { value: current-value, on-change }
    button {}, "add child node"


editor = ({ graph, current-value, on-change }) ->
  div { style: { flex: "1 1" } },
    node { graph, current-value, on-change }


map-state-to-props = ({ graph, current-value, foo }) ->
  { graph, current-value, foo }


map-dispatch-to-props = (dispatch) ->
  { on-change: (text) -> dispatch { type: \CHANGE_CURRENT_NODE, text } }


module.exports = editor |> connect map-state-to-props, map-dispatch-to-props
