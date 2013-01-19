express    = require 'express'
services   = require './server/business/services'
router     = require './server/router/router'
config     = require './server/business/config'
mongo      = config.mongo

MongoStore = require( 'connect-mongo' )( express )

#test services
#test       = require './test-services'

#set app
app = module.exports = express.createServer()

#set default app configure
app.configure = ->
	app.set 'views', __dirname + '/client/views'
	app.set 'view engine', 'html'
	app.register '.html', require 'ejs'
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use express.static __dirname + '/client/public'
	app.use express.cookieParser 'asgard-cookie'
	app.use express.session 
		secret : 'asgard-session-secret'
		cookie : 
			maxAge : 2 * 24 * 60 * 60 * 1000
		store  : new MongoStore
			url: config.get_monog_url mongo
	app.use( app.router )
	app.set 'view options', { layout : false }

#set app development configure
app.configure 'development', ->
	app.use express.errorHandler({ showStack: true, dumpExceptions: true })

#set app production configure
app.configure 'production', ->
	#TO DO

#roter( app )
router app

#listen
app.listen config.port

#print server host & port
console.log "Server start at http://#{ config.host }:#{ config.port }"

#connect services
services.once 'services_connected_success', ( result ) ->
	console.log 'services connected'
	#test.adminsSave()
	#test.operatorsSave()
	#test.categoriesSave()
	#test.contentsSave()
services.once 'services_connected_error', ( error ) ->
	console.log "error = #{ error }"
services.connect( config.get_monog_url mongo )