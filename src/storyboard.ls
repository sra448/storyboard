{ DOM } = require \react
{ render } = require \react-dom
{ Graph } = require \graphlib
{ div } = DOM

editor = require "./editor.ls"
player = require "./player.ls"


model =
  current-node: 1
  graph: (new Graph).set-node 1, "hello?"


ui = ->
  div { style: { display: \flex, width: "100%" } },
    player { model }
    editor { model }


render (ui {}), document.get-element-by-id \storyboard
