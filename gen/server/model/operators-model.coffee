services = require 'mongoose'
vo       = require './vo/operators'
events   = require 'events'
exports  = module.exports = new events.EventEmitter();

exports.OperatorsModel = OperatorsModel = services.model 'c-operators', vo.OperatorsSchema

#查询username和password
exports.find = ( obj, query, radom ) ->
	obj.findOne { 'username' : query.username.toLowerCase(), 'password' : query.password.toLowerCase() }, ( err , operators ) ->
		if not err 
			exports.emit radom + '_operators_signin_success', if operators is null then operators else vo.obj2json operators
		else
			exports.emit radom + '_operators_signin_error', err

#查询全部
exports.findAll = ( obj, radom ) ->
	query = obj.find {}
	query.sort 'cdate', 1
	query.exec ( err , operators ) ->
		if not err 
			exports.emit radom + '_operators_findall_success', operators
		else
			exports.emit radom + '_operators_findall_error', err

#查询username
exports.findUsername = ( obj, username, radom ) ->
	obj.findOne { 'username' : username.toLowerCase() }, ( err , operators ) ->
		if not err 
			exports.emit radom + '_operators_findusername_success', operators
		else
			exports.emit radom + '_operators_findusername_error', err

#operators add
exports.add = ( obj, radom ) ->
  obj.save ( err ) ->
    if not err
      exports.emit radom + '_operators_add_success', null
    else
      exports.emit radom + '_operators_add_error', err

#operator save
exports.save = ( obj, username, updates, random ) ->

	conditions = { username  : username }
	updates    = { $set : updates }
	options    = { multi: true }

	obj.update conditions, updates, options, ( err ) ->
	    if not err
	      exports.emit random + '_operators_save_success', 'succeess'
	    else
	      exports.emit random + '_operators_save_error', err

#delete by uid
exports.delete = ( obj, username, random ) ->
	obj.findOne { 'username' : username }, ( err, operator ) ->
		if not err 
			operator.remove()
			operator.save ( err ) ->
				if not err 
					exports.emit random + '_operators_delete_success', 'succeess'
				else
					exports.emit random + '_operators_delete_error', err
		else
			exports.emit random + '_operators_delete_error', err
