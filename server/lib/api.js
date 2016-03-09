var db = require('./database')
var PriceWatcher = require('./price-watcher')
var notifyToken = PriceWatcher.notifyToken
var clearToken = PriceWatcher.clearToken
var express = require('express')
var app = express()
var bodyParser = require('body-parser')

app.use(bodyParser.json())

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
        console.log(err)
        return res.send({error: 'Unexpected error'})
      }
      notifyToken(deviceToken)
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
        console.log(err)
        return res.send({error: 'Unexpected error'})
      }
      clearToken(deviceToken)
      return res.send({result: 'ok'})
    }
  )
})

module.exports = {
  start: function(port) {
    app.listen(port, '0.0.0.0')
    console.log('[' + new Date() + '] API started on port ' + port)
  }
}
