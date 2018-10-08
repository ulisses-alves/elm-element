import '@webcomponents/webcomponentsjs/webcomponents-bundle'
import { define } from 'elm-element'
import { Elm } from './BasicEventBinding.elm'


const App = define(Elm.BasicEventBinding.init, {
  events: {
    change: 'valueChanged'
  }
})

customElements.define('my-app', App)


const myApp = document.querySelector('my-app')

myApp.addEventListener('change', event => {
  alert(`Received "change" event with value "${event.detail}"`)
})