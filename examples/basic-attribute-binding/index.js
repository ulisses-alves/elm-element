import '@webcomponents/webcomponentsjs/webcomponents-bundle'
import { define } from 'elm-element'
import { Elm } from './BasicAttributeBinding.elm'


const App = define(Elm.BasicAttributeBinding.init, {
  attributes: {
    value: 'onValue'
  }
})

customElements.define('my-app', App)
