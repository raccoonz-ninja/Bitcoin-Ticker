var checkPrice = require('./lib/price-watcher').checkPrice
var api = require('./lib/api')

checkPrice(1000)
api.start(5567)
