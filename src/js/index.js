import React from 'react'
import { render } from 'react-dom'
import { Router, Route, Link, IndexRedirect, browserHistory } from 'react-router'

// var app = Elm.Main.fullscreen({
//   user: ${JSON.stringify(req.session.user || null)}
// })
//
// window.addEventListener('message', function(e) {
//   app.ports.loginCompleteRaw.send(e.data)
// })
//
// app.ports.loginStart.subscribe(function() {
//   window.open('/connect/twitter')
// })

const App = ({ children }) => (
  <div>
    <div>
      <Link to="/login">Login</Link>
      <Link to="/compose">Compose</Link>
      <Link to="/about">About</Link>
    </div>
    {children}
  </div>
)

const About = (stuff) => {
  console.log(stuff)
  return (
    <div>about</div>
  )
}

const Login = () => (
  <div>login</div>
)

const Compose = () => (
  <div>compose</div>
)

render((
  <Router history={browserHistory}>
    <Route path="/" component={App}>
      <IndexRedirect to="login" />
      <Route path="login" component={Login} />
      <Route path="compose" component={Compose} />
      <Route path="about" component={About} />
    </Route>
  </Router>
), document.getElementById('app'))
