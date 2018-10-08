# elm-element
This library is meant to streamline the process of turning [Elm](http://elm-lang.org/) applications into custom HTML elements. This is specially useful when mixing Elm with other frameworks, such as React, Vue, etc., and even within another Elm application.

## Usage
A given date picker Elm application could be setup as follows:

```index.html```
```html
<my-datepicker value="1538991615340"></my-datepicker>
```

```index.js```
```javascript
import { define } from 'elm-element'
import { Elm } from './DatePicker.elm'

// Define the custom element class
const DatePicker = define(Elm.DatePicker.init, {
  properties: {
    value: 'onChangeValue'
  },
  events: {
    change: 'valueChanged'
  }
})

// Register element to be used as <my-datepicker>
customElements.define('my-datepicker', DatePicker)
```

```DatePicker.elm```
```elm
port module DatePicker exposing (main)

main : Program Flags Model Msg
main ...

-- Initial observed attributes and properties values are passed as flags
type alias Flags =
  { attributes :
    { value : Maybe String
    }
  }

-- When subscribed, notifies Elm that the attribute has been changed from the outside
port onChangeValue : ( Maybe String -> msg ) -> Sub msg

-- Triggers the "change" event with provided value
port valueChanged : Int -> Cmd msg
```

## Disclaimer
The example above makes use of a loader such as [elm-webpack-loader](https://www.npmjs.com/package/elm-webpack-loader) and [rollup-plugin-elm](https://www.npmjs.com/package/rollup-plugin-elm) to be able to import Elm files into JavaScript.

It's also important to note that Custom Elements and Shadow DOM are not yet completely supported by all major browsers, so it's advisable to use a [polyfill](https://www.webcomponents.org/polyfills) when necessary.

## API

```
define(init [, config])
```
### ```init```
A function that takes an object as follows:
```typescript
{
  node: HTMLElement,
  flags: {
    attributes: {
      [name: string]: null | string
    }
  }
}
```
And then returns an Elm app instance. Custom behavior can be achieved by specifying your own function instead of Elm's standard ```init``` function:
```javascript
define(({ node, flags }) => {
  return Elm.App.init({
    node: node,
    flags: {
      ...flags,
      someExtraFlag: Date.now()
    }
  })
})
```

### ```config```

#### Attributes
Observing an attribute can be specified as follows:
```javascript
{
  attributes: {
    value: 'valueChanged'
  }
}
```
Where ```value``` is the attribute's name and ```valueChanged``` is the incoming port name. The example above is a shorthand for:
```javascript
{
  attributes: {
    value: (app, newValue) =>
      app.ports.valueChanged.send(newValue)
  }
}
```
From inside the Elm application, changes to the attribute can be received by the incoming port with specified name:
```elm
-- App.elm

port valueChanged : (Maybe String -> msg) -> Sub msg
```

#### Properties
Observing a properties works much like as attributes:
```javascript
{
  properties: {
    value: 'valueChanged'
  }
}
```
As well as:
```javascript
{
  properties: {
    value: (app, newValue) =>
      app.ports.valueChanged.send(newValue)
  }
}
```
With the difference that properties can be any JSON serializable value:
```elm
-- App.elm

import Json.Decode as Json

port valueChanged : (Json.Value -> msg) -> Sub msg
```

#### Events
Similarly, events can be defined as:
```javascript
{
  events: {
    change: 'valueChange'
  }
}
```
Which is a shorthand for:
```javascript
{
  events: {
    change: (app, dispatch) =>
      app.ports.valueChange.subscribe(dispatch)
  }
}
```
And if you want to take charge of creating the custom event yourself, it can be done as follows:
```javascript
{
  events: {
    change: (app, dispatch) =>
      app.ports.valueChange.subscribe(newValue => {
        dispatch(new CustomEvent('change', {
          detail: newValue
        }))
      })
  }
}
```
Events can be dispached from Elm using an outgoing port:
```elm
-- App.elm

port valueChange : Json.Value -> Cmd msg
```

Check out the ```examples``` directory for complete examples.

## Development
Issues, suggestions and pull requests are very much welcomed. Feel free to also contact me directly on [Slack](http://elmlang.herokuapp.com/).
