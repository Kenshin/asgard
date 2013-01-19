services = require 'mongoose'
vo       = require './vo/contents'
events   = require 'events'
exports  = module.exports = new events.EventEmitter();

exports.ContentsModel = ContentsModel = services.model 'c-contents', vo.ContentsSchema

#get count
exports.count = ( obj, query, random ) ->
	obj.count query, ( err, contents ) ->
		if not err 
			exports.emit random + '_contents_count_success', contents
		else
			exports.emit random + '_contents_count_error', err

#find all
exports.findAll = findAll = ( obj, query, page, pagesize, random ) ->
	query = obj.find query
	query.sort 'uid', 1
	query.skip page * pagesize - pagesize
	query.limit pagesize
	query.exec ( err, contents ) ->
		if not err 
			exports.emit random + '_contents_findall_success', contents
		else
			exports.emit random + '_contents_findall_error', err

#find contents by url
exports.findURL = ( obj, url, random ) ->
	obj.findOne { 'url' : url }, ( err, contents ) ->
		if not err 
			exports.emit random + '_contents_findurl_success', contents
		else
			exports.emit random + '_contents_findurl_error', err

#count contents by catename
exports.countCatename = ( obj, catename, random ) ->
	obj.find { 'catename' : catename }, ( err, contents ) ->
		if not err 
			exports.emit random + '_contents_countcatename_success', contents.length
		else
			exports.emit random + '_contents_countcatename_error', err

#count contents by operator
exports.countOperator = ( obj, operator, random ) ->
	obj.find { 'username' : operator }, ( err, contents ) ->
		if not err 
			console.log 'operator = ' + operator
			exports.emit random + '_contents_countoperator_success', contents.length
		else
			exports.emit random + '_contents_countoperator_error', err

#contents add
exports.add = ( obj, random ) ->
  obj.save ( err ) ->
    if not err
      exports.emit random + '_contents_save_success', 'succeess'
    else
      #console.log '_contents_save_error' + err
      exports.emit random + '_contents_save_error', err

#edit by uid
exports.edit = ( obj, uid, random ) ->
	obj.findOne { 'uid' : uid }, ( err, content ) ->
		if not err 
			exports.emit random + '_contents_edit_success', content
		else
			exports.emit random + '_contents_edit_error', err

#contents save
exports.save = ( obj, conditions, updates, random ) ->

	updates    = { $set : updates }
	options    = { multi: true }

	obj.update conditions, updates, options, ( err ) ->
	    if not err
	      exports.emit random + '_contents_update_success', 'succeess'
	    else
	      exports.emit random + '_contents_update_error', err

#delete by uid
exports.delete = ( obj, uid, random ) ->
	obj.findOne { 'uid' : uid }, ( err, content ) ->
		if not err 
			content.remove()
			content.save ( err ) ->
				if not err 
					exports.emit random + '_contents_delete_success', 'succeess'
				else
					exports.emit random + '_contents_delete_error', err
		else
			exports.emit random + '_contents_delete_error', err
