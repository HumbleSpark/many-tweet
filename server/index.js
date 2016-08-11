const express = require('express')
  , logger = require('morgan')
  , session = require('express-session')
  , bodyParser = require('body-parser')
  , path = require('path')
  , Twitter = require('twitter')
  , Grant = require('grant-express')
  , { SESSION_SECRET, CONSUMER_KEY, CONSUMER_SECRET, PROTOCOL, HOST, PORT } = process.env

const createClient = (access_token_key, access_token_secret) => {
  return new Twitter({
    consumer_key: CONSUMER_KEY,
    consumer_secret: CONSUMER_SECRET,
    access_token_key,
    access_token_secret
  })
}

const post = (client, url, params) => {
  return new Promise((resolve, reject) => {
    client.post(url, params, (error, result) => {
      if (error) reject(error)
      else resolve(result)
    })
  })
}

const grant = new Grant({
  server: {
    protocol: PROTOCOL,
    host: HOST
  },
  twitter: {
    key: CONSUMER_KEY,
    secret: CONSUMER_SECRET,
    callback: '/handle_twitter_callback'
  }
})

var app = express()
app.use(express.static(path.join(__dirname, '../build')))
app.use(logger('dev'))
app.use(session({
  secret: SESSION_SECRET,
  secure: PROTOCOL === 'https'
}))
app.use(grant)
app.use(bodyParser.json())
app.use((req, res, next) => {
  if(req.header('x-forwarded-proto') !== PROTOCOL) {
    res.redirect(`${PROTOCOL}://${req.header('host')}${req.url}`)
  } else {
    next()
  }
})

app.post('/post_tweets', (req, res) => {
  if (!req.session.auth) {
    res.sendStatus(403)
    return
  }

  const { access_token, access_secret } = req.session.auth
  const client = createClient(access_token, access_secret)

  const tweets = req.body.tweets;
  if (tweets.length === 0) {
    res.sendStatus(400)
    return
  } else {
    let ids = []
    const promise = tweets.reduce((promise, nextTweet) => {
      return promise.then((tweet) => {
        return post(client, 'statuses/update', {
          status: nextTweet,
          in_reply_to_status_id: tweet ? tweet.id_str : undefined
        })
        .then((newTweet) => {
          ids.push(newTweet.id_str)
          return newTweet
        })
      })
    }, Promise.resolve())

    console.log(ids)

    promise
      .then(() => {
        res.json({ tweetId: ids[0] })
      })
      .catch((e) => {
        return Promise.all(ids.map((nextId) => {
          console.log(nextId)
          return post(client, `statuses/destroy/${nextId}`, { trim_user: true })
        }))
        .then(() => {
          res.sendStatus(500)
        })
        .catch(() => {
          res.sendStatus(500)
        })
      })
  }
})


const callbackHtml = (user) => {
  return `<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
  </head>
  <body>
    <script>
      window.opener.postMessage(${JSON.stringify(user)}, '${PROTOCOL}://${HOST}')
      window.close()
    </script>
  </body>
</html>
`
}


app.get('/handle_twitter_callback', function (req, res) {
  const client = createClient(req.query.access_token, req.query.access_secret)

  if (req.query.error) {
    res.send(callbackHtml(null))
    return
  }

  client.get('users/show', { screen_name: req.query.raw.screen_name }, (error, user) => {
    if (error) {
      res.send(callbackHtml(null))
    } else {
      req.session.auth = req.query
      req.session.user = {
        id: user.id_str,
        username: user.screen_name,
        image: user.profile_image_url,
        color : '#' + user.profile_link_color
      }
      res.send(callbackHtml(req.session.user))
    }
  })
})


app.get('/', (req, res) => {
  res.send(
`<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="user-scalable=no,initial-scale=1,minimum-scale=1,maximum-scale=1,width=device-width" />
    <link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:400,300,600' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="main.css" />
  </head>
  <body>
    <script src="main.js"></script>
    <script>
      var app = Elm.Main.fullscreen({
        user: ${JSON.stringify(req.session.user || null)}
      })

      window.addEventListener('message', function(e) {
        app.ports.loginCompleteRaw.send(e.data)
      })

      app.ports.loginStart.subscribe(function() {
        window.open('/connect/twitter')
      })
    </script>
  </body>
</html>
`
  )
})

app.listen(PORT, function() {
  console.log('Express server listening on port ' + PORT)
})
