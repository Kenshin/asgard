#admins collection
admins_model = require '../model/admins-model'
AdminsModel  = admins_model.AdminsModel

#operators collection
operators_model = require '../model/operators-model'
OperatorsModel  = operators_model.OperatorsModel

#init signin
exports.init = ( req, res ) ->
	res.render 'back-end/signin', { message : 'init' }

#用来判断是admin登陆、还是operator登陆
exports.signin = ( req, res ) ->

	#打印
	console.log '-- asgard-signin(POST) -- '
	console.log 'req.body.username = ' + req.body.username
	console.log 'req.body.password = ' + req.body.password
	console.log 'req.body.role     = ' + req.body.role
	console.log 'req.body.remember = ' + req.body.remember

	#生成一个json对象
	obj =
		username : req.body.username
		password : req.body.password
		role     : req.body.role
		remember : req.body.remember
	if obj.role == 'admin' then adminsigin obj, req, res else operatorsigin obj, req, res

#admin登陆验证
adminsigin = ( obj, req, res ) ->

	#生成随机字符串
	random = require( '../libs/random' ).random

	#监听调用admins_model.find的事件
	admins_model.once random + '_admins_signin_success', ( result ) ->

		#打印输出结果
		console.log 'result_admins_signin_success = ' + result

		#如果result == ''说明，查询失败
		#反之，说明查询成功。
		if result is null
			#查询失败，传入失败的信息
			res.render 'back-end/signin', { message : '用户名/密码错误！' }
		else 
			#当选择保存登陆状态时，将用户信息保存到session中
			if obj.remember == 'yes'
				req.session.member = JSON.stringify( result )
			#设置cookies
			res.cookie 'member', JSON.stringify( result )
			#重定向到dashboard页面
			res.redirect '/dashboard'

	admins_model.once random + '_admins_signin_error', ( error ) ->
		console.log 'result_admins_signin_error = ' + err

	#调用admins_model.find方法
	admins_model.find AdminsModel, obj, random

#operator登陆验证
operatorsigin = ( obj, req, res ) ->

	#生成随机字符串
	random = require( '../libs/random' ).random

	#监听调用operators_model.find的事件
	operators_model.once random + '_operators_signin_success', ( result ) ->

		#打印输出结果
		console.log 'result_operators_signin_success = ' + result

		#如果result == ''说明，查询失败
		#反之，说明查询成功。
		if result is null
			#查询失败，传入失败的信息
			res.render 'back-end/signin', { message : '用户名/密码错误！' }
		else 
			#当选择保存登陆状态时，将用户信息保存到session中
			if obj.remember == 'yes'
				req.session.member = JSON.stringify( result )
			#设置cookies
			res.cookie 'member', JSON.stringify( result )
			#重定向到dashboard页面
			res.redirect '/dashboard'

	operators_model.once random + '_operators_signin_error', ( error ) ->
		console.log 'result_operators_signin_error = ' + err

	#调用operators_model.find方法
	operators_model.find OperatorsModel, obj, random

#sign out
exports.signout = ( req, res ) ->

	#打印
	console.log '-- signout -- '

	req.session.destroy()
	res.clearCookie 'member'
	res.redirect '/asgard-signin'
