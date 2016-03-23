var db = require('./database')
var PriceWatcher = require('./price-watcher')
var express = require('express')
var app = express()
var bodyParser = require('body-parser')

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({extended: true}))

app.get('/', function(req, res){
  res.send('What\'s up?')
})

checkParam = function(param, name) {
  if (!param || param === '') {
    return'parameter `' + name + '` missing'
  }
}

app.post('/subscribe', function(req, res) {
  // Param validation
  params = req.body
  deviceToken = params.deviceToken
  provider = params.provider
  error = checkParam(deviceToken, 'deviceToken')
  error = checkParam(provider, 'provider')
  if (error) { return res.send(error) }

  console.log('[' + new Date() + '] /subscribe ' + deviceToken + '/' + provider)
  db.update(
    { deviceToken: deviceToken },
    { deviceToken: deviceToken, provider: provider },
    { upsert: true },
    function (err) {
      if (err) {
        console.error('[' + new Date() + '] ' + err)
        return res.send({error: 'Unexpected error'})
      }
      PriceWatcher.notifyToken(deviceToken)
      return res.send({result: 'ok'})
    }
  )
})

app.post('/unsubscribe', function(req, res) {
  // Param validation
  params = req.body
  deviceToken = params.deviceToken
  error = checkParam(deviceToken, 'deviceToken')
  if (error) { return res.send({error: error}) }

  console.log('[' + new Date() + '] /unsubscribe ' + deviceToken)
  db.remove(
    { deviceToken: deviceToken },
    { multi: true },
    function (err, numRemoved) {
      if (err) {
        console.error('[' + new Date() + '] ' + err)
        return res.send({error: 'Unexpected error'})
      }
      PriceWatcher.clearToken(deviceToken)
      return res.send({result: 'ok'})
    }
  )
})

app.post('/fakePrice', function(req, res) {
  params = req.body
  try {
    newPrice = parseFloat(params.price)
    duration = Math.min(Math.max(parseFloat(params.duration), 0), 300)
    pass = params.pass
    if (!isNaN(newPrice) && !isNaN(duration) && pass == 'sdl70@sv926potato') {
      PriceWatcher.overridePrice(newPrice, duration)
      return res.send({result: 'ok'})
    } else {
      return res.send({result: 'invalid parameters'})
    }
  } catch (err) {
    console.error('[' + new Date() + '] ' + err)
    return res.send({result: 'Unexpected error'})
  }
})

module.exports = {
  start: function(port) {
    app.listen(port, '0.0.0.0')
    console.log('[' + new Date() + '] API started on port ' + port)
  }
}
