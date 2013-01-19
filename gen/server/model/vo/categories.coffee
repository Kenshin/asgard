services = require 'mongoose'
Schema   = services.Schema
ObjectId = Schema.ObjectId

obj = 
  id       : ObjectId
  catename : String
  alias    : String
  cdate : 
    type    : Date
    default : Date.now 
  mdate : 
    type    : Date
    default : Date.now 

exports.CategoriesSchema = new Schema obj