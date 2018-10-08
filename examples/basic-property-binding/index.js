import '@webcomponents/webcomponentsjs/webcomponents-bundle'
import { define } from 'elm-element'
import { Elm } from './BasicPropertyBinding.elm'


const App = define(Elm.BasicPropertyBinding.init, {
  properties: {
    value: 'onValue'
  }
})

customElements.define('my-app', App)
