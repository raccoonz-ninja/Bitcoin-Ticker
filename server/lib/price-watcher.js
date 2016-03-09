var request = require('request')
var apn = require('apn')
var db = require('./database')

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
    lastPrice = roundedPrice
    notifyAll()
  }
}

var notifyAll = function() {
  db.find({}, function(err, doc) {
    if (err) {
      console.log(err)
    } else {
      console.log('[' + new Date() + '] Sending push notification to ' + doc.length + ' devices ($' + lastPrice + ').')
      doc.forEach(function (user) {
        notifyToken(user.deviceToken)
      })
    }
  })
}

var notifyToken = function(deviceToken) {
  setBadge(deviceToken, lastPrice)
}
var clearToken = function(deviceToken) {
  setBadge(deviceToken, 0)
}
setBadge = function(deviceToken, badgeCount) {
  try {
    var myDevice = new apn.Device(deviceToken)
    var note = new apn.Notification()
    // note.expiry = Math.floor(Date.now() / 1000) + 3600; // Expires 1 hour from now.
    note.badge = badgeCount
    apnConnection.pushNotification(note, myDevice)
  } catch (error) {
    console.log(error)
  }
}

var checkPrice = function(next) {
  request('https://api.bitfinex.com/v1/pubticker/BTCUSD', function(err, res, body) {
    var data = JSON.parse(body)
    var last = parseFloat(data.last_price)
    onNewPrice(last)
    setTimeout(checkPrice, next)
  })
}

module.exports = {
  checkPrice: checkPrice,
  notifyToken: notifyToken,
  clearToken: clearToken
}
