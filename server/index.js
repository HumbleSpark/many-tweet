const express = require('express')
const logger = require('morgan')
const session = require('express-session')
const bodyParser = require('body-parser')
const path = require('path')
const Twitter = require('twitter')
const Grant = require('grant-express')
const url = require('url')
const RedisStore = require('connect-redis')(session)
const config = require('./config')()

const createClient = (access_token_key, access_token_secret) => {
  return new Twitter({
    consumer_key: config.consumerKey,
    consumer_secret: config.consumerSecret,
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
    protocol: config.protocol,
    host: config.grantHost
  },
  twitter: {
    key: config.consumerKey,
    secret: config.consumerSecret,
    callback: '/handle_twitter_callback'
  }
})

const sessionConfig = process.env.NODE_ENV === 'production' ?
  {
    secret: config.sessionSecret,
    store: new RedisStore({
      ttl: parseInt(config.sessionTtl),
      url: config.redisUrl
    })
  } :
  {
    secret: config.sessionSecret
  }

var app = express()
app.use(express.static(path.join(__dirname, '../build')))
app.use(logger('dev'))
app.use(session(sessionConfig))
app.use(grant)
app.use(bodyParser.json())

if (process.env.NODE_ENV === 'production') {
  app.use((req, res, next) => {
    if(req.header('x-forwarded-proto') !== config.protocol) {
      res.redirect(`${config.protocol}://${req.header('host')}${req.url}`)
    } else {
      next()
    }
  })
}

app.post('/post_tweets', (req, res) => {
  if (!req.session.auth) {
    res.sendStatus(403)
    return
  }

  const { token, secret } = req.session.auth
  const client = createClient(token, secret)

  const tweets = req.body.tweets;
  if (tweets.length === 0) {
    res.sendStatus(400)
    return
  } else {
    const ids = []
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

    promise
      .then(() => {
        res.json({ tweetId: ids[0] })
      })
      .catch(() => {
        return Promise.all(ids.map((nextId) => {
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
      window.opener.postMessage(${JSON.stringify(user)}, '${config.protocol}://${config.grantHost}')
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
      req.session.auth = {
        token: req.query.access_token,
        secret: req.query.access_secret
      }

      req.session.user = {
        id: user.id_str,
        username: user.screen_name,
        image: user.profile_image_url_https,
        color : '#' + user.profile_link_color
      }
      res.send(callbackHtml(req.session.user))
    }
  })
})


app.get('/*', (req, res) => {
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
    <div id="app"></div>
    <script src="main.js"></script>
  </body>
</html>
`
  )
})

app.listen(config.port, function() {
  console.log('Express server listening on port ' + config.port)
})
