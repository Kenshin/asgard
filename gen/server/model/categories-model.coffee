services = require 'mongoose'
vo       = require './vo/categories'
events   = require 'events'
exports  = module.exports = new events.EventEmitter();

exports.CategoriesModel = CategoriesModel = services.model 'c-categories', vo.CategoriesSchema

#查询全部
exports.findAll = ( obj, radom ) ->
	query = obj.find {}
	query.sort 'cdate', 1
	query.exec ( err , categories ) ->
		if not err 
			exports.emit radom + '_categories_findall_success', categories
		else
			exports.emit radom + '_categories_findall_error', err

#查询catename
exports.findCatename = ( obj, catename, radom ) ->
	obj.findOne { 'catename' : catename.toLowerCase() }, ( err , categories ) ->
		if not err 
			exports.emit radom + '_categories_findcatename_success', categories
		else
			exports.emit radom + '_categories_findcatename_error', err

#categories add
exports.add = ( obj, radom ) ->
  obj.save ( err ) ->
    if not err
      exports.emit radom + '_categories_add_success', null
    else
      exports.emit radom + '_categories_add_error', err

#categories save
exports.save = ( obj, catename, updates, random ) ->

	conditions = { catename  : catename }
	updates    = { $set : updates }
	options    = { multi: true }

	obj.update conditions, updates, options, ( err ) ->
	    if not err
	      exports.emit random + '_categories_save_success', 'succeess'
	    else
	      exports.emit random + '_categories_save_error', err

#delete by catenanme
exports.delete = ( obj, catename, random ) ->
	obj.findOne { 'catename' : catename }, ( err, category ) ->
		if not err 
			category.remove()
			category.save ( err ) ->
				if not err 
					exports.emit random + '_categories_delete_success', 'succeess'
				else
					exports.emit random + '_categories_deletee_error', err
		else
			exports.emit random + '_categories_delete_error', err
