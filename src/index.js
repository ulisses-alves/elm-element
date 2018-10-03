const defaultConfig = {
  attributes: {},
  properties: {},
  events: {}
}


export function define (init, config = {}) {
  const cfg = Object.assign({}, defaultConfig, config)
  const attributeHandler = createIncomingMessageHandler(cfg.attributes)
  const propertyHandler = createIncomingMessageHandler(cfg.properties)
  const eventHandler = createOutgoingMessageHandler(cfg.events)

  class ElmElement extends HTMLElement {
    constructor () {
      super()
      setupElement(
        this,
        init,
        attributeHandler,
        propertyHandler,
        eventHandler
      )
    }
  }

  Object.defineProperty(ElmElement, 'observedAttributes', {
    value: Object.keys(attributeHandler)
  })

  Object.defineProperties(
    ElmElement.prototype,
    createPropertyInterceptor(propertyHandler)
  )

  Object.defineProperty(ElmElement.prototype, 'attributeChangedCallback', {
    value: attributeChangedCallbackFor(attributeHandler)
  })

  return ElmElement
}


// ELEMENT SETUP

function setupElement (
  element,
  init,
  attributeHandler,
  propertyHandler,
  eventHandler
) {
  const container = createContainerOn(element)

  element.app = createApp(
    element,
    container,
    init,
    Object.keys(attributeHandler),
    Object.keys(propertyHandler)
  )

  Object.keys(eventHandler).forEach(event => {
    const subscribe = eventHandler[event]
    subscribe(value => {
      element.dispatchEvent(
        value instanceof CustomEvent
          ? value
          : new CustomEvent(event, { detail: value })
      )
    })
  })
}


function createContainerOn (element) {
  const shadow = element.attachShadow({ mode: 'open' })
  const container = document.createElement('div')
  shadow.appendChild(container)
  return container
}


function createApp (
  element,
  container,
  initApp,
  attributeNames,
  propertyNames
) {
  return initApp({
    node: container,
    flags: {
      attributes: attributeFlags(element, attributeNames),
      properties: propertyFlags(element, propertyNames)
    }
  })
}

function attributeFlags (element, attributeNames) {
  return attributeNames.reduce(
    (res, name) => {
      res[name] = element.getAttribute(name)
      return res
    },
    {}
  )
}

function propertyFlags (element, propertyNames) {
  return propertyNames.reduce(
    (res, name) => {
      res[name] = element[name] === undefined
        ? null
        : element[name]
      return res
    },
    {}
  )
}

function attributeChangedCallbackFor (attributeHandlers) {
  return function attributeChangedCallback (name, oldValue, newValue) {
    attributeHandlers[name](this.app, newValue)
  }
}

function createPropertyInterceptor (propertyHandler) {
  return Object.keys(propertyHandler).reduce(
    (res, name) => {
      res[name] = {
        get () {
          return this[`_elm_element_prop__${name}`]
        },
        set (value) {
          this[`_elm_element_prop__${name}`] = value
          propertyHandler[name](this.app, value)
        }
      }
      return res
    },
    {}
  )
}


// MESSAGE HANDLERS

function createIncomingMessageHandler (config) {
  return Object.keys(config).reduce(
    (res, name) => {
      const value = config[name]

      res[name] = typeof value === 'string'
        ? defaultSendFor(value)
        : value

      return res
    },
    {}
  )
}


function createOutgoingMessageHandler (config) {
  return Object.keys(config).reduce(
    (res, name) => {
      const value = config[name]

      res[name] = typeof value === 'string'
        ? defaultSubscribeFor(value)
        : value

      return res
    },
    {}
  )
}

function defaultSendFor (name) {
  return (app, newValue) =>
    app.ports && app.ports[name] && app.ports[name].send
      ? app.ports[name].send(newValue)
      : console.warn(`Could not find incroming port named: ${name}`)
}

function defaultSubscribeFor (name) {
  return (app, dispatch) =>
    app.ports && app.ports[name] && app.ports[name].subscribe
      ? app.ports[name].subscribe(dispatch)
      : console.warn(`Could not find outgoing port named: ${name}`)
}