{ create-store } = require \redux
{ create-element, DOM } = require \react
{ render } = require \react-dom
{ Provider } = require \react-redux

reducer = require "./reducer.ls"
ui = require "./ui.ls"


store = create-store reducer
app = create-element Provider, { store }, ui {}


render app, document.get-element-by-id \storyboard
