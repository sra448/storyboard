{ connect } = require \react-redux
{ DOM } = require \react
{ div, button } = DOM


messages = ({ graph, history }) ->
  div {},
    for { who, id } in history
      div { key: "m#{id}", class-name: "message #{who}"}, (graph.node id).text


answers = ({ graph, current-node, on-decision }) ->
  div {},
    for { w, v } in graph.out-edges current-node
      button { key: "a#{w}", class-name: "answer", on-click: on-decision w }, (graph.node w).text


player = ({ graph, current-node, history, on-reset-player, on-decision }) ->
  div { class-name: "player" },
    button { on-click: on-reset-player }, "reset player"
    messages { graph, history }
    answers { graph, current-node, on-decision } if (graph.out-edges current-node)?.length > 0




map-state-to-props = ({ graph, current-node, history, foo }) ->
  { graph, current-node, history, foo }


map-dispatch-to-props = (dispatch) ->
  on-decision: (id) -> -> dispatch { type: \CHOOSE_NEXT_NODE, id }
  on-reset-player: -> dispatch { type: \RESET_PLAYER }



module.exports = player |> connect map-state-to-props, map-dispatch-to-props
