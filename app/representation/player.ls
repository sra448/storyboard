{ connect } = require \react-redux
{ DOM } = require \react
{ div, button } = DOM


message = ({ graph, current-node })->
  value = graph.node current-node
  div { class-name: "message" }, value


messages = ({ history }) ->
  div {},
    for { who, text } in history
      div { class-name: "message #{who}"}, text


answers = ({ graph, current-node, on-decision }) ->
  div {},
    for { w, v } in graph.out-edges current-node
      button { class-name: "answer", on-click: on-decision w }, graph.node w


player = ({ graph, current-node, history, on-decision }) ->
  div { class-name: "player" },
    messages { history }
    answers { graph, current-node, on-decision } if (graph.out-edges current-node)?.length > 0


map-state-to-props = ({ graph, current-node, history, foo }) ->
  { graph, current-node, history, foo }


map-dispatch-to-props = (dispatch) ->
  on-decision: (id) -> -> dispatch { type: \CHOOSE_NEXT_NODE, id }



module.exports = player |> connect map-state-to-props, map-dispatch-to-props
