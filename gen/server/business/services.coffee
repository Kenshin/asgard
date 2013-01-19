db      = require 'mongoose'
events  = require 'events'
exports = module.exports = new events.EventEmitter();

#连接mongodb数据库
exports.connect = ( url ) ->
	try 
		console.log 'mongodb url = ' + url
		db.connect url
		exports.emit 'services_connected_success', 'success'
	catch error
		console.log "mongodb connect error#{ error }"
		exports.emit 'services_connected_error', error