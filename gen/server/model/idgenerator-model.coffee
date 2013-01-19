services = require 'mongoose'
vo       = require './vo/idgenerator'
events   = require 'events'
exports  = module.exports = new events.EventEmitter();

exports.IdGeneratorModel = IdGeneratorModel = services.model 'c-idgenerator', vo.IdGeneratorSchema

exports.getNewID = ( obj, modelName, callback ) ->

	obj.findOne { modelname : modelName }, ( err, doc ) ->
		
        if doc
            doc.currentid += 1
        else
            doc = new IdGeneratorModel()
            doc.modelname = modelName
        
        doc.save ( err ) ->
            if err
            	throw err 'IdGenerator.getNewID.save() error' 
            else 
            	callback parseInt doc.currentid.toString()
