#categories collection
categories_model     = require '../model/categories-model'
CategoriesModel      = categories_model.CategoriesModel

content              = require './content'

#get getcategoies
exports.getcategoies = ( req, res, obj, callback ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#call findAll
	categories_model.once random + '_categories_findall_success', ( result ) ->
		console.log '_categories_findall_success = ' + result
		callback req, res, obj, result
	categories_model.once random + '_categories_findall_error', ( err ) ->
		console.log '_categories_findall_error = ' + err
	#exec
	categories_model.findAll CategoriesModel, random

#add category
exports.add = ( req, res ) ->
	#打印
	console.log 'req.body.catename   = ' + req.body.catename
	console.log 'req.body.catealias  = ' + req.body.catealias

	obj           = new CategoriesModel()
	obj.catename  = req.body.catename
	obj.alias     = req.body.catealias

	#生成随机字符串
	random = require( '../libs/random' ).random
	#add
	categories_model.once random + '_categories_add_success', ( result ) ->
		console.log '_categories_add_success = ' + result
		res.redirect '/dashboard'
	categories_model.once random + '_categories_add_error', ( err ) ->
		console.log '_categories_add_error = ' + err
	#exec
	categories_model.add obj, random

#edit category
exports.edit = ( req, res ) ->

	#打印参数
	console.log 'req.params.catename = ' + req.params.catename

	#生成随机字符串
	random = require( '../libs/random' ).random

	#
	categories_model.once random + '_categories_findcatename_success', ( result ) ->
		#console.log '_categories_findcatename_success =' + result
		res.partial 'back-end/category-modal', { category : result }
	categories_model.once random + '_categories_findcatename_error', ( err ) ->
		console.log '_categories_findcatename_error = ' + err
	categories_model.findCatename CategoriesModel, req.params.catename, random

#save category
exports.save = ( req, res ) ->
	#打印
	console.log 'req.body.catename   = ' + req.body.catename
	console.log 'req.body.orgcatename= ' + req.body.orgcatename
	console.log 'req.body.catealias  = ' + req.body.catealias
	
	#生成随机字符串
	random = require( '../libs/random' ).random

	updates = 
		catename : req.body.catename
		alias    : req.body.catealias

	#
	categories_model.once random + '_categories_save_success', ( result ) ->
		#console.log '_categories_save_success =' + result
		conditions = { catename : req.body.orgcatename }
		updates = 
			catename  : req.body.catename
			catealias : req.body.catealias
			mdate     : new Date()
		content.updateCate req, res, conditions, updates
		
	categories_model.once random + '_categories_save_error', ( err ) ->
		console.log '_categories_save_error = ' + err
	categories_model.save CategoriesModel, req.body.orgcatename, updates, random

#delete category
exports.delete = ( req, res ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#call findAll
	categories_model.once random + '_categories_delete_success', ( result ) ->
		console.log '_categories_delete_success = ' + result
		res.partial 'back-end/success'
	categories_model.once random + '_categories_delete_error', ( err ) ->
		console.log '_categories_delete_error = ' + err
	#exec
	categories_model.delete CategoriesModel, req.params.catename, random

#check catename unique
exports.checkunique = ( req, res ) ->

	#打印参数
	console.log 'req.params.catename = ' + req.params.catename

	#生成随机字符串
	random = require( '../libs/random' ).random

	#
	categories_model.once random + '_categories_findcatename_success', ( result ) ->
		console.log '_categories_findcatename_success =' + result + '|'
		if `result == '' || result == null`
			res.partial 'back-end/success'
		else
			res.partial 'back-end/unsuccess'
	categories_model.once random + '_categories_findcatename_error', ( err ) ->
		console.log '_categories_findcatename_error = ' + err
	categories_model.findCatename CategoriesModel, req.params.catename, random
