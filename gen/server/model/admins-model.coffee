services = require 'mongoose'
vo       = require './vo/admins'
events   = require 'events'
exports  = module.exports = new events.EventEmitter();

exports.AdminsModel = AdminsModel = services.model 'c-admins', vo.AdminsSchema

#查询username和password
exports.find = ( obj, query, radom ) ->
	obj.findOne { 'username' : query.username.toLowerCase(), 'password' : query.password.toLowerCase() }, ( err , admin ) ->
		if not err 
			exports.emit radom + '_admins_signin_success', if admin is null then admin else vo.obj2json admin
		else
			exports.emit radom + '_admins_signin_error', err

#查询username
exports.findUsername = ( obj, username, radom ) ->
	obj.findOne { 'username' : username.toLowerCase() }, ( err , admin ) ->
		if not err 
			exports.emit radom + '_admins_findusername_success', admin
		else
			exports.emit radom + '_admins_findusername_error', err

#find all
exports.findAll = ( obj, radom ) ->
	obj.find {}, ( err , admins ) ->
		if not err 
			exports.emit radom + '_admins_findall_success', admins
		else
			exports.emit radom + '_admins_findall_error', err

#operators add
exports.add = ( obj, radom ) ->
  obj.save ( err ) ->
    if not err
      exports.emit radom + '_admins_add_success', null
    else
      exports.emit radom + '_admins_add_error', err

#admin save
exports.save = ( obj, username, updates, random ) ->

	conditions = { username  : username }
	updates    = { $set : updates }
	options    = { multi: true }

	obj.update conditions, updates, options, ( err ) ->
	    if not err
	      exports.emit random + '_admins_save_success', 'succeess'
	    else
	      exports.emit random + '_admins_save_error', err
