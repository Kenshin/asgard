services = require 'mongoose'
Schema   = services.Schema
ObjectId = Schema.ObjectId

#define obj
obj = 
  id        : ObjectId
  modelname : String
  currentid : 
    type    : Number
    default : 1

#export IdGeneratorSchema
exports.IdGeneratorSchema = new Schema obj