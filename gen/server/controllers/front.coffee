#pagination
pagination          = require 'node-pagination'
#contents collection
contents_model      = require '../model/contents-model'
ContentsModel       = contents_model.ContentsModel
#category controller
category            = require './category'

#global variables
#每页显示的条数
pagesize   = 5
#全局catename
catename   = null
#操作员
operator   = null
#当前状态
state      = null

#articles
exports.articles = ( req, res ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#console.log req.params.page
	console.log 'req.params.page = ' + req.params.page
	#set page no
	pageno = if `req.params.page != undefined` then req.params.page else 1
	#设定当前类型
	state = 'index'
	#call findAll
	contents_model.once random + '_contents_count_success', ( result ) ->
		#console log
		console.log '-- _contents_count_success --'
		#invoke page
		getpagination req, res, result, pageno
	contents_model.once random + '_contents_count_error', ( err ) ->
		console.log '_contents_count_error = ' + err
	#由于每次文章总数可能会发生变化，所以，需要每次重新取得pagetotal
	contents_model.count ContentsModel, {}, random

#类型
exports.category = ( req, res ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#设定当前类型
	state = 'category'
	#set catename
	catename = if `req.params.catename != undefined` then req.params.catename else res.redirect '/'
	console.log 'catename =========== ' + catename
	#set pageno
	pageno   = if `req.params.page != undefined` then req.params.page else 1
	console.log 'pageno ============= ' + pageno
	#
	contents_model.once random + '_contents_countcatename_success', ( result ) ->
		console.log '_contents_countcatename_success =' + result + '|'
		#call page function
		getpagination req, res, result, pageno
	contents_model.once random + '_contents_countcatename_error', ( err ) ->
		console.log '_contents_countcatename_error = ' + err
	#由于每次分类总数可能会发生变化，所以，需要每次重新取得catetotal
	contents_model.countCatename ContentsModel, catename, random

#用户
exports.operator = ( req, res ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#设定当前类型
	state = 'operator'
	#set operator
	operator = if `req.params.operator != undefined` then req.params.operator else res.redirect '/'
	console.log 'operator =========== ' + operator
	#set pageno
	pageno = if `req.params.page != undefined` then req.params.page else 1
	console.log 'pageno ============= ' + pageno
	#
	contents_model.once random + '_contents_countoperator_success', ( result ) ->
		console.log '_contents_countoperator_success =' + result + '|'
		#call page function
		getpagination req, res, result, pageno
	contents_model.once random + '_contents_countoperator_error', ( err ) ->
		console.log '_contents_countoperator_error = ' + err
	#每次都重新计算分页数
	contents_model.countOperator ContentsModel, operator, random

#取得contents，包括：全部文章和分类文章
getpagination = ( req, res, total, pageno ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#set pv
	pv = pagination.build total, pageno, pagesize, 0, pagesize
	#call findAll
	contents_model.once random + '_contents_findall_success', ( result ) ->
		#set obj,inclue contents & pv
		obj = 
			contents : result
			pv       : pv
		#由于每次分类内容可能会发生变化，所以，需要每次重新取得categories
		category.getcategoies req, res, obj, getCategoiesHandler
	contents_model.once random + '_contents_findall_error', ( err ) ->
		console.log '_contents_findall_error = ' + err
	#exec
	#
	if state == 'index'
		query = {}
	else if state == 'category'
		query = { catename : catename }
	else if state == 'operator'
		query = { username : operator }
	contents_model.findAll ContentsModel, query, pageno, pagesize, random

#文章详细页
exports.detail = ( req, res ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#设定当前类型
	state = 'detail'
	#set url
	url = if `req.params.url != undefined` then req.params.url else res.redirect '/'
	#
	contents_model.once random + '_contents_findurl_success', ( result ) ->
		console.log '_contents_findurl_success =' + result + '|'
		#set obj,inclue contents & pv
		obj = 
			contents : result
			pv       : null
		#由于每次分类内容可能会发生变化，所以，需要每次重新取得categories
		category.getcategoies req, res, obj, getCategoiesHandler
	contents_model.once random + '_contents_findurl_error', ( err ) ->
		console.log '_contents_findurl_error = ' + err
	contents_model.findURL ContentsModel, url, random

#category.getcategoies callback
getCategoiesHandler = ( req, res, obj, result ) ->
	#res.render
	if state != 'detail'
		res.render 'front-end/index', { contents : obj.contents, pv : obj.pv, categories : result, state : state }
	else 
		res.render 'front-end/detail', { content : obj.contents, categories : result }
