{ connect } = require \react-redux
{ DOM } = require \react
{ div } = DOM


node = ({ graph })->
  value = graph.node 1
  div {}, value


player = ({ graph }) ->
  div { style: { flex: "1 1" } },
    node { graph }


map-state-to-props = ({ graph, foo }) ->
  { graph, foo }


map-dispatch-to-props = (dispatch) ->
  { on-slot-click: (id) -> dispatch { type: \SLOT_FREE, id } }


module.exports = player |> connect map-state-to-props, map-dispatch-to-props
