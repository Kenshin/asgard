#admins collection
admins_model  = require '../model/admins-model'
AdminsModel   = admins_model.AdminsModel

#setup admin
exports.setup = ( req, res ) ->
	
	#生成随机字符串
	random = require( '../libs/random' ).random

	#
	admins_model.once random + '_admins_findall_success', ( result ) ->
		#console.log '_admins_findall_success =|' + result + '|'
		#res.render 'back-end/setup'
		if `result != ''` then res.redirect '/' else res.render 'back-end/setup'
	admins_model.once random + '_admins_findall_error', ( err ) ->
		console.log '_admins_findall_error = ' + err
	admins_model.findAll AdminsModel, random

exports.add = ( req, res ) ->
	#打印
	console.log 'req.body.username   = ' + req.body.username
	console.log 'req.body.password   = ' + req.body.password
	console.log 'req.body.alias      = ' + req.body.alias
	console.log 'req.body.email      = ' + req.body.email
	console.log 'req.body.role       = ' + req.body.role

	obj           = new AdminsModel()
	obj.username  = req.body.username
	obj.password  = req.body.password
	obj.alias     = req.body.alias
	obj.email     = req.body.email
	obj.role      = req.body.role

	#生成随机字符串
	random = require( '../libs/random' ).random
	#add
	admins_model.once random + '_admins_add_success', ( result ) ->
		#console.log '_admins_add_success = ' + result
		res.redirect '/asgard-signin'
	admins_model.once random + '_admins_add_error', ( err ) ->
		console.log '_admins_add_error = ' + err
	#exec
	admins_model.add obj, random


#save（ userinfo ） admin
exports.profile = ( req, res ) ->
	#打印
	console.log 'req.body.username   = ' + req.body.username
	console.log 'req.body.password   = ' + req.body.password
	console.log 'req.body.alias      = ' + req.body.alias
	console.log 'req.body.email      = ' + req.body.email
	console.log 'req.body.role       = ' + req.body.role
	
	#生成随机字符串
	random = require( '../libs/random' ).random

	updates = 
		username : req.body.username
		password : req.body.password
		alias    : req.body.alias
		email    : req.body.email
		role     : req.body.role
		mdate    : new Date()

	#当用户名发生改变时，需要更新contents表，因此需要调用content.updateUsername
	admins_model.once random + '_admins_save_success', ( result ) ->
		console.log '_admins_save_success =' + result
		res.redirect '/admin-profile'

	admins_model.once random + '_admins_save_error', ( err ) ->
		console.log '_admins_save_error = ' + err
	admins_model.save AdminsModel, req.body.username, updates, random

#update（ userinfo ） admin
exports.updateprofile = ( req, res ) ->
	#set member
	member = setMember req, res
	#打印参数
	console.log 'member.username = ' + member.username

	#生成随机字符串
	random = require( '../libs/random' ).random

	#
	admins_model.once random + '_admins_findusername_success', ( result ) ->
		console.log '_admins_findusername_success =' + result
		#更新session以及cookies
		if `req.session.member != null`
			req.session.member = JSON.stringify result

		res.cookie 'member', JSON.stringify( result )
		res.redirect '/dashboard'
		
	admins_model.once random + '_admins_findusername_error', ( err ) ->
		console.log '_admins_findusername_error = ' + err
	admins_model.findUsername AdminsModel, member.username, random

#set member
setMember = ( req, res ) ->
	#set global member
	member = if req.session.member then req.session.member else req.cookies.member
	#保存到session或cookies里面的内容只能为字符串，所以需要将其转换为json对象
	member = JSON.parse( member )
