{ DOM } = require \react
{ div } = DOM


node = ({ model })->
  current-value = model.graph.node 1
  div {}, current-value


module.exports = ({ model }) ->
  div { style: { flex: "1 1" } },
    node { model }
