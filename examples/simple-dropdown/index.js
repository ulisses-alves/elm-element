import '@webcomponents/webcomponentsjs/webcomponents-bundle'
import { define } from 'elm-element'
import app from './SimpleDropdown/App.elm'


const Dropdown = define(
  ({ node, flags }) =>
    app.Elm.SimpleDropdown.App.init({
      node: node,
      flags: {
        seed: Date.now()
      }
    })
)


customElements.define('my-dropdown', Dropdown)