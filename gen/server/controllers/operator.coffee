#operators collection
operators_model     = require '../model/operators-model'
OperatorsModel      = operators_model.OperatorsModel

content             = require './content'

#get operators
exports.getoperators = ( req, res, contents, pv , callback ) ->
	#set member
	#member = setMember req, res
	#生成随机字符串
	random = require( '../libs/random' ).random
	#call findAll
	operators_model.once random + '_operators_findall_success', ( result ) ->
		#console.log '_operators_findall_success = ' + result
		#callback req, res, { member : member, contents : contents, pv : pv, operators : result }
		callback req, res, { contents : contents, pv : pv, operators : result }
	operators_model.once random + '_operators_findall_error', ( err ) ->
		console.log '_operators_findall_error = ' + err
	#exec
	operators_model.findAll OperatorsModel, random

#add operator
exports.add = ( req, res ) ->
	#打印
	console.log 'req.body.username   = ' + req.body.username
	console.log 'req.body.password   = ' + req.body.password
	console.log 'req.body.alias      = ' + req.body.alias
	console.log 'req.body.email      = ' + req.body.email
	console.log 'req.body.role       = ' + req.body.role

	obj           = new OperatorsModel()
	obj.username  = req.body.username
	obj.password  = req.body.password
	obj.alias     = req.body.alias
	obj.email     = req.body.email
	obj.role      = req.body.role

	#生成随机字符串
	random = require( '../libs/random' ).random
	#add
	operators_model.once random + '_operators_add_success', ( result ) ->
		console.log '_operators_add_success = ' + result
		res.redirect '/dashboard'
	operators_model.once random + '_operators_add_error', ( err ) ->
		console.log '_operators_add_error = ' + err
	#exec
	operators_model.add obj, random

#edit operator
exports.edit = ( req, res ) ->

	#打印参数
	console.log 'req.params.username = ' + req.params.username

	#生成随机字符串
	random = require( '../libs/random' ).random

	#
	operators_model.once random + '_operators_findusername_success', ( result ) ->
		#console.log '_operators_findusername_success =' + result
		res.partial 'back-end/operator-modal', { operator : result }
	operators_model.once random + '_operators_findusername_error', ( err ) ->
		console.log '_operators_findusername_error = ' + err
	operators_model.findUsername OperatorsModel, req.params.username, random

#save operator
exports.save = ( req, res ) ->
	#打印
	console.log 'req.body.username   = ' + req.body.username
	console.log 'req.body.orgusername= ' + req.body.orgusername
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
	operators_model.once random + '_operators_save_success', ( result ) ->
		#console.log '_operators_save_success =' + result
		if req.body.username is req.body.orgusername then res.redirect '/dashboard' else content.updateUsername req, res, req.body.orgusername, req.body.username
		
	operators_model.once random + '_operators_save_error', ( err ) ->
		console.log '_operators_save_error = ' + err
	operators_model.save OperatorsModel, req.body.orgusername, updates, random

#delete opeartor
exports.delete = ( req, res ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#call findAll
	operators_model.once random + '_operators_delete_success', ( result ) ->
		console.log '_operators_delete_success = ' + result
		res.partial 'back-end/success'
	operators_model.once random + '_operators_delete_error', ( err ) ->
		console.log '_operators_delete_error = ' + err
	#exec
	operators_model.delete OperatorsModel, req.params.username, random

#check username unique
exports.checkunique = ( req, res ) ->

	#打印参数
	console.log 'req.params.username = ' + req.params.username

	#生成随机字符串
	random = require( '../libs/random' ).random

	#
	operators_model.once random + '_operators_findusername_success', ( result ) ->
		console.log '_operators_findusername_success =' + result + '|'
		if `result == '' || result == null`
			res.partial 'back-end/success'
		else
			res.partial 'back-end/unsuccess'
	operators_model.once random + '_operators_findusername_error', ( err ) ->
		console.log '_operators_findusername_error = ' + err
	operators_model.findUsername OperatorsModel, req.params.username, random

#save（ userinfo ） operator
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
	operators_model.once random + '_operators_save_success', ( result ) ->
		console.log '_operators_save_success =' + result
		res.redirect '/operator-profile'

	operators_model.once random + '_operators_save_error', ( err ) ->
		console.log '_operators_save_error = ' + err
	operators_model.save OperatorsModel, req.body.username, updates, random

#update（ userinfo ） operator
exports.updateprofile = ( req, res ) ->
	#set member
	member = setMember req, res
	#打印参数
	console.log 'member.username = ' + member.username

	#生成随机字符串
	random = require( '../libs/random' ).random

	#
	operators_model.once random + '_operators_findusername_success', ( result ) ->
		console.log '_operators_findusername_success =' + result
		#更新session以及cookies
		if `req.session.member != null`
			req.session.member = JSON.stringify result

		res.cookie 'member', JSON.stringify( result )
		res.redirect '/dashboard'
		
	operators_model.once random + '_operators_findusername_error', ( err ) ->
		console.log '_operators_findusername_error = ' + err
	operators_model.findUsername OperatorsModel, member.username, random

#set member
setMember = ( req, res ) ->
	#set global member
	member = if req.session.member then req.session.member else req.cookies.member
	#保存到session或cookies里面的内容只能为字符串，所以需要将其转换为json对象
	member = JSON.parse( member )
