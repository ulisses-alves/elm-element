import { define } from 'elm-element'
import app from './App.elm'
import tooltip from './Tooltip.elm'


const App = define(app.Elm.App.init)

const Tooltip = define(tooltip.Elm.Tooltip.init, {
  attributes: {
    text: 'onTextChange'
  },
  events: {
    show: 'tooltipShown',
    hide: 'tooltipHidden'
  }
})


customElements.define('my-app', App)
customElements.define('my-tooltip', Tooltip)