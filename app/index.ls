{ create-store } = require \redux
{ create-element, DOM } = require \react
{ render } = require \react-dom
{ Provider } = require \react-redux
{ Observable } = require \rx


reducer = require "./logic/reducer.ls"
ui = require "./representation/storyboard.ls"


ROOT = document.get-element-by-id \storyboard


store = create-store reducer
app = create-element Provider, { store }, ui {}


mouse-down$ = Observable.fromEvent ROOT, \mousedown
mouse-move$ = Observable.fromEvent ROOT, \mousemove
mouse-up$ = Observable.fromEvent ROOT, \mouseup


draw-edge$ = do
  mouse-down$
    .filter ({ target }) -> target.class-name == "new-edge"
    .do (e) -> e.stop-propagation()
    .flat-map ({ target }) ->
      id = target.id
      mouse-move$
        .map mouse-coords-to-tile-coords
        .distinct-until-changed!
        .map ({ x, y }) -> { type: \CHANGE_TEMP_EDGE_POSITION, x, y }
        .start-with { type: \ADD_TEMP_EDGE, id }
        .take-until mouse-up$
        .concat Observable.return { type: \CLOSE_TEMP_EDGE }



draw-edge$.subscribe (action) ->
  store.dispatch action


mouse-coords-to-tile-coords = ({ page-x, page-y }) ->
  { x: page-x, y: page-y }


render app, ROOT
