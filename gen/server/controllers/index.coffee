#首页

#pagination
pagination          = require 'node-pagination'

#contents collection
contents_model      = require '../model/contents-model'
ContentsModel       = contents_model.ContentsModel

category            = require './category'

#pagination 每页显示的条数
pagesize   = 5
#全局当前页数
pageno     = 1
#全局总文章数
pagetotal  = -1

#全局分类总数
catetotal  = -1
#全局categories
categories = null
#全局catename
catename   = null

#member user name
operator   = null
#全局member total
operatortotal = -1

#当前状态
state      = null

#index init
exports.init = init = ( req, res ) ->
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
		#set page total
		pagetotal = result;
		#invoke page
		page req, res, pagetotal, pageno
	contents_model.once random + '_contents_count_error', ( err ) ->
		console.log '_contents_count_error = ' + err
	#由于每次文章总数可能会发生变化，所以，需要每次重新取得pagetotal
	contents_model.count ContentsModel, {}, random

	#total == -1说明并没有取得分页，所以需要调用contents_model.count
	#total != -1说明分页已经取得过，直接进行下面的逻辑运算
	#if pagetotal == -1
	#	#exec
	#	contents_model.count ContentsModel, {}, random
	#else
	#	#invoke page
	#	page req, res, pagetotal, pageno

#类型
exports.category = ( req, res ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#设定当前类型
	state = 'category'
	#set category，分类未定义时，跳转到首页
	if req.params.catename == undefined
		res.redirect '/'
	#换分类时需要初期化以下变量
	else if req.params.catename != undefined && req.params.catename != catename
		catename   = req.params.catename
		#catetotal  = -1
	console.log 'catetotal ============ ' + catetotal
	console.log 'catename ============= ' + catename
	#set pageno
	pageno = if `req.params.page != undefined` then req.params.page else 1
	#
	contents_model.once random + '_contents_countcatename_success', ( result ) ->
		console.log '_contents_countcatename_success =' + result + '|'
		#设定全局最大数
		catetotal = result
		#call page function
		page req, res, catetotal, pageno
	contents_model.once random + '_contents_countcatename_error', ( err ) ->
		console.log '_contents_countcatename_error = ' + err
	#由于每次分类总数可能会发生变化，所以，需要每次重新取得catetotal
	contents_model.countCatename ContentsModel, catename, random
	
	#catetotal == -1说明并没有取得分页，所以需要调用contents_model.countCatename
	#catetotal != -1说明分页已经取得过，直接进行下面的逻辑运算
	#if catetotal == -1
	#	contents_model.countCatename ContentsModel, catename, random
	#else
	#	#call page function
	#	page req, res, catetotal, pageno

#用户
exports.operator = ( req, res ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#设定当前类型
	state = 'operator'
	#set operator，分类未定义时，跳转到首页
	if req.params.operator == undefined
		res.redirect '/'
	#换分类时需要初期化以下变量
	else if req.params.operator != undefined && req.params.operator != operator
		operator       = req.params.operator
		operatortotal  = -1
	console.log 'operatortotal ============ ' + operatortotal
	console.log 'operator      ============= ' + operator
	#set pageno
	pageno = if `req.params.page != undefined` then req.params.page else 1
	#
	contents_model.once random + '_contents_countoperator_success', ( result ) ->
		console.log '_contents_countoperator_success =' + result + '|'
		#设定全局最大数
		operatortotal = result
		#call page function
		page req, res, operatortotal, pageno
	contents_model.once random + '_contents_countoperator_error', ( err ) ->
		console.log '_contents_countoperator_error = ' + err
	
	#operatortotal == -1说明并没有取得分页，所以需要调用contents_model.countOperator
	#operatortotal != -1说明分页已经取得过，直接进行下面的逻辑运算
	if operatortotal == -1
		contents_model.countOperator ContentsModel, operator, random
	else
		#call page function
		page req, res, operatortotal, pageno

#取得contents，包括：全部文章和分类文章
page = ( req, res, total, pageno ) ->
	#生成随机字符串
	random = require( '../libs/random' ).random
	#set pv
	pv = getpagination total, pageno
	#call findAll
	contents_model.once random + '_contents_findall_success', ( result ) ->
		#set obj,inclue contents & pv
		obj = 
			contents : result
			pv       : pv
		#由于每次分类内容可能会发生变化，所以，需要每次重新取得categories
		category.getcategoies req, res, obj, getCategoiesHandler
		#categories == null说明未取得categories，因此需要重新取得
		#if categories == null
		#	#call category.getcategoies
		#	category.getcategoies req, res, obj, getCategoiesHandler
		#else
		#	res.render 'front/index', { contents : obj.contents, pv : obj.pv, categories : categories, state : state }
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

#category.getcategoies callback
getCategoiesHandler = ( req, res, obj, result ) ->
	#set global
	categories = result
	#res.render
	res.render 'front/index', { contents : obj.contents, pv : obj.pv, categories : categories, state : state }

#get pagination vo
getpagination = ( total, pageno ) ->
	pagination.build total, pageno, pagesize, 0, pagesize

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
		#categories == null说明未取得categories，因此需要重新取得
		if categories == null
			#call category.getcategoies
			#set obj,inclue contents & pv
			category.getcategoies req, res, result, ( req, res, obj, result ) ->
				categories = result
				res.render 'front/detail', { content : obj, categories : categories }
		else
			res.render 'front/detail', { content : result, categories : categories }
	contents_model.once random + '_contents_findurl_error', ( err ) ->
		console.log '_contents_findurl_error = ' + err
	contents_model.findURL ContentsModel, url, random