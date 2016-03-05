var Datastore = require('nedb')
var db = new Datastore({ filename: './db', autoload: true })

module.exports = db
