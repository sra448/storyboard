{ create-element, DOM } = require \react
{ div } = DOM

editor = require "./editor.ls"
player = require "./player.ls"

require "./style.scss"


module.exports = ->
  div { class-name: "storyboard" },
    create-element editor, {}
    create-element player, {}
