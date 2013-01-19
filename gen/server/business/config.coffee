exports.port    = process.env.VMC_APP_PORT or 10080
exports.host    = process.env.VCAP_APP_HOST or 'localhost'

#判断是本机运行 还是 cloudfoundry 运行
if process.env.VCAP_SERVICES
  env   = JSON.parse process.env.VCAP_SERVICES
  mongo = env[ 'mongodb-1.8' ][ 0 ][ 'credentials' ]
else
  mongo =
    'hostname' : 'localhost'
    'port'     : 27017
    'username' : ''
    'password' : ''
    'db'       : 'asdb'

#mongo object
exports.mongo = mongo;

#set mongo url
exports.get_monog_url = ( obj ) ->
	if process.env.VCAP_SERVICES then "mongodb://#{ obj.username }:#{ obj.password }@#{ obj.hostname }:#{ obj.port }/#{ obj.db }" else "mongodb://#{ obj.hostname }:#{ obj.port }/#{ obj.db }"
