{ create-element, DOM } = require \react
{ div } = DOM

editor = require "./editor.ls"
player = require "./player.ls"


module.exports = ({ model }) ->
  div { style: { display: \flex, width: "100%" } },
    create-element player, { model }
    create-element editor, { model }
