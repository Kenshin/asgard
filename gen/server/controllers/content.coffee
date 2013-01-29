#admins collection
contents_model      = require '../model/contents-model'
ContentsModel       = contents_model.ContentsModel

#idgenerator
idgenerator_model   = require '../model/idgenerator-model'
IdGeneratorModel    = idgenerator_model.IdGeneratorModel

#categories collection
categories_model    = require '../model/categories-model'
CategoriesModel     = categories_model.CategoriesModel

#content new
exports.new = ( req, res ) ->

	#set member
	member = setMember req, res

	#判断是否是operator的权限
	res.redirect '/dashboard' if member.role is 'admin'

	result = 
		uid       : 0
		title     : ''
		pic       : ''
		url       : ''
		catename  : ''
		catealias : ''
		content   : '内容'

	categoriesfindall req, res, result, 'new'

#content add
exports.add = ( req, res ) ->

	#set member
	member = setMember req, res

	#判断是否是operator的权限
	res.redirect '/dashboard' if member.role is 'admin'

	#get new id
	idgenerator_model.getNewID IdGeneratorModel, 'uid', ( newid ) ->

		#打印
		console.log 'new id value       = ' + newid
		console.log 'req.body.title     = ' + req.body.title
		console.log 'req.body.url       = ' + req.body.url
		console.log 'req.body.pic       = ' + req.body.pic
		console.log 'req.body.content   = ' + req.body.content
		console.log 'req.body.catealias = ' + req.body.catealias
		console.log 'req.body.catename  = ' + req.body.catename
		console.log 'member.username    = ' + member.username

		#生成随机字符串
		random = require( '../libs/random' ).random

		obj           = new ContentsModel()
		obj.uid       = newid
		obj.username  = member.username
		obj.url       = `req.body.url == '' ? newid : req.body.url`
		obj.title     = req.body.title
		obj.pic       = req.body.pic
		obj.content   = req.body.content
		obj.catename  = req.body.catename
		obj.catealias = req.body.catealias

		contents_model.once random + '_contents_save_success', ( result ) ->
			console.log '_contents_save_success'
			res.redirect '/dashboard'
		contents_model.once random + '_contents_save_error', ( err ) ->
			console.log '_contents_save_error' + err
		contents_model.add obj, random 

#content edit
exports.edit = ( req, res ) ->

	#set member
	member = setMember req, res

	#生成随机字符串
	random = require( '../libs/random' ).random

	#edit from contents-model
	contents_model.once random + '_contents_edit_success', ( result ) ->
		console.log '_contents_edit_success = ' + result
		categoriesfindall req, res, result, 'edit'
	contents_model.once random + '_edit_delete_error', ( err ) ->
		console.log '_contents_edit_error = ' + err
	contents_model.edit ContentsModel, req.params.uid, random

#content save
exports.save = ( req, res ) ->

	#set member
	member = setMember req, res

	#打印
	console.log 'req.body.title     = ' + req.body.title
	console.log 'req.body.url       = ' + req.body.url
	console.log 'req.body.pic       = ' + req.body.pic
	console.log 'req.body.content   = ' + req.body.content
	console.log 'req.body.catealias = ' + req.body.catealias
	console.log 'req.body.catename  = ' + req.body.catename
	console.log 'req.params.uid     = ' + req.params.uid

	#生成随机字符串
	random = require( '../libs/random' ).random

	updates = 
		title     : req.body.title
		url       : req.body.url
		pic       : req.body.pic
		catename  : req.body.catename
		catealias : req.body.catealias
		content   : req.body.content
		mdate     : new Date()

	#save from contents-model
	contents_model.once random + '_contents_update_success', ( result ) ->
		console.log '_contents_update_success = ' + result
		res.redirect '/dashboard'
	contents_model.once random + '_contents_update_error', ( err ) ->
		console.log '_contents_update_error = ' + err
	contents_model.save ContentsModel, { uid : req.params.uid }, updates, random

#content cancel
exports.cancel = ( req, res ) ->
	res.redirect '/dashboard'

#content delete
exports.delete = ( req, res ) ->

	#set member
	member = setMember req, res

	#生成随机字符串
	random = require( '../libs/random' ).random

	#delete from contents-model
	contents_model.once random + '_contents_delete_success', ( result ) ->
		console.log '_contents_delete_success = ' + result
		res.render 'back-end/success'
	contents_model.once random + '_contents_delete_error', ( err ) ->
		console.log '_contents_delete_error = ' + err
	contents_model.delete ContentsModel, req.params.uid, random

#check url unique
exports.checkunique = ( req, res ) ->

	#打印参数
	console.log 'req.params.url = ' + req.params.url

	#set member
	member = setMember req, res

	#生成随机字符串
	random = require( '../libs/random' ).random

	#
	contents_model.once random + '_contents_findurl_success', ( result ) ->
		console.log '_contents_findurl_success =' + result + '|'
		if `result == '' || result == null`
			res.render 'back-end/success'
		else
			res.render 'back-end/unsuccess'
	contents_model.once random + '_contents_findurl_error', ( err ) ->
		console.log '_contents_findurl_error = ' + err
	contents_model.findURL ContentsModel, req.params.url, random

#update username
exports.updateUsername = ( req, res, orgusername, username ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random

	updates = 
		username  : username
		mdate     : new Date()

	#save from contents-model
	contents_model.once random + '_contents_update_success', ( result ) ->
		console.log '_contents_update_success = ' + result
		res.redirect '/dashboard'
	contents_model.once random + '_contents_update_error', ( err ) ->
		console.log '_contents_update_error = ' + err
	contents_model.save ContentsModel, { username : orgusername }, updates, random

#update catename and catealias
exports.updateCate = ( req, res, conditions, updates ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random

	#save from contents-model
	contents_model.once random + '_contents_update_success', ( result ) ->
		console.log '_contents_update_success = ' + result
		res.redirect '/dashboard'
	contents_model.once random + '_contents_update_error', ( err ) ->
		console.log '_contents_update_error = ' + err
	contents_model.save ContentsModel, conditions, updates, random

#find all from categories
categoriesfindall = ( req, res, content, type ) ->

	#set member
	member = setMember req, res

	#生成随机字符串
	random = require( '../libs/random' ).random

	#find all from categories-model
	categories_model.once random + '_categories_findall_success', ( result ) ->
		res.render 'back-end/content', { member : member, content : content, categories : result, type : type }
	categories_model.once random + '_categories_findall_error', ( err ) ->
		console.log '_categories_findall_error = ' + err
	categories_model.findAll CategoriesModel, random

#set member
setMember = ( req, res ) ->
	#set global member
	member = if req.session.member then req.session.member else req.cookies.member
	#保存到session或cookies里面的内容只能为字符串，所以需要将其转换为json对象
	member = JSON.parse( member )
