module.exports = () => {
  if (process.env.NODE_ENV === 'production') {
    const { REDIS_URL, SESSION_TTL, SESSION_SECRET, CONSUMER_KEY, CONSUMER_SECRET, PROTOCOL, HOST, PORT } = process.env
    return {
      redisUrl: REDIS_URL,
      sessionTtl: SESSION_TTL,
      sessionSecret: SESSION_SECRET,
      consumerKey: CONSUMER_KEY,
      consumerSecret: CONSUMER_SECRET,
      protocol: PROTOCOL,
      host: HOST,
      port: PORT,
      grantHost: HOST
    }
  } else {
    const { CONSUMER_KEY, CONSUMER_SECRET, SESSION_SECRET } = process.env
    return {
      sessionSecret: 'secret',
      consumerKey: CONSUMER_KEY,
      consumerSecret: CONSUMER_SECRET,
      protocol: 'http',
      host: 'manytweetdev.com',
      port: '1337',
      grantHost: 'manytweetdev.com:1337'
    }
  }
}
