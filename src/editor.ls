{ DOM } = require \react
{ div, input, button } = DOM


node = ({ model })->
  current-value = model.graph.node 1
  div {},
    input { value: current-value }
    button {}, "add child node"


module.exports = ({ model }) ->
  div { style: { flex: "1 1" } },
    node { model }
