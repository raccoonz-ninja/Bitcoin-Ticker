var request = require('request')
var apn = require('apn')
var Datastore = require('nedb')
var db = new Datastore({ filename: './db', autoload: true })

var options = {passphrase: 'sdl70@sv926'}
var apnConnection = new apn.Connection(options)

// db.insert({
//   deviceToken: '8459525a2515c871d3922f839e35564863bf921d7df107e750c3527efb6fb001',
//   market: 'bitfinex'
// })

var lastPrice = null

// deviceToken, market = bitfinex

var onNewPrice = function(newPrice) {
  roundedPrice = Math.floor(newPrice)
  if (!lastPrice || lastPrice !== roundedPrice) {
    sendPushNotifications(roundedPrice)
  }
  lastPrice = roundedPrice
}

var sendPushNotifications = function(newPrice) {
  db.find({}, function(err, doc) {
    if (err) {
      console.log(err)
    } else {
      doc.forEach(function (user) {
        var myDevice = new apn.Device(user.deviceToken)
        var note = new apn.Notification()
        // note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
        note.badge = newPrice
        apnConnection.pushNotification(note, myDevice)
      })
      console.log('Sending push notification to ' + doc.length + ' devices ($' + newPrice + ').')
    }
  })
}

var checkPrice = function() {
  request('https://api.bitfinex.com/v1/pubticker/BTCUSD', function(err, res, body) {
    var data = JSON.parse(body)
    var last = parseFloat(data.last_price)
    onNewPrice(last)
  })
}

setInterval(checkPrice, 1000)
