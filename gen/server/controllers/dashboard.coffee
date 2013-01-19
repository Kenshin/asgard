#pagination
pagination          = require 'node-pagination'

#contents collection
contents_model      = require '../model/contents-model'
ContentsModel       = contents_model.ContentsModel

operator            = require './operator'
category            = require './category'

pageno   = 1
pagesize = 10
pv       = {}
total    = 1

#dashboard init
exports.init = ( req, res ) ->
	#init pageno
	pageno   = 1
	#set member
	member = setMember req, res
	#生成随机字符串
	random = require( '../libs/random' ).random

	#call count
	contents_model.once random + '_contents_count_success', ( result ) ->
		#set total
		total = result;
		#get pagination
		pv = getpagination() if `result != null && result > 0`
		#invoke page
		page req, res 
	contents_model.once random + '_contents_count_error', ( err ) ->
		console.log '_contents_count_error = ' + err
	#set query
	query = if member.role is 'admin' then {} else { 'username' : member.username }
	#exec
	contents_model.count ContentsModel, query, random

#dashboard page
exports.page = page = ( req, res ) ->

	#set page
	pageno = if `req.params.page != undefined` then req.params.page else 1
	#set member
	member = setMember req, res
	#生成随机字符串
	random = require( '../libs/random' ).random
	#re-set pv
	pv = getpagination()

	#call findAll
	contents_model.once random + '_contents_findall_success', ( result ) ->
		if req.xhr
			res.partial 'back-end/content-table', { contents : result, pv : pv }
		else
			#如果当前用户为admin的话，就继续取得operators和categories
			if member.role is 'admin' then operator.getoperators req, res, result, pv, getOperatorsHandler else res.render 'back-end/dashboard', { member : member, contents : result, pv : pv }
	contents_model.once random + '_contents_findall_error', ( err ) ->
		console.log '_contents_findall_error = ' + err
	#set query
	query = if member.role is 'admin' then {} else { 'username' : member.username }
	#exec
	contents_model.findAll ContentsModel, query, pageno, pagesize, random

#operator.getoperators callback
getOperatorsHandler = ( req, res, obj ) ->
	#category.getcategoies req, res, result
	category.getcategoies req, res, obj, getCategoiesHandler

#category.getcategoies callback
getCategoiesHandler = ( req, res, obj, result ) ->
	#set member
	member = setMember req, res
	#res.render
	res.render 'back-end/dashboard', { member : member, contents : obj.contents, pv : obj.pv, operators : obj.operators, categories : result }

#get pagination vo
getpagination = ->
	pagination.build total, pageno, pagesize, 0, pagesize

#set member
setMember = ( req, res ) ->
	#set global member
	member = if req.session.member then req.session.member else req.cookies.member
	#保存到session或cookies里面的内容只能为字符串，所以需要将其转换为json对象
	member = JSON.parse( member )
