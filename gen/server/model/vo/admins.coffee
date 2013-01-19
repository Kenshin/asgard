services = require 'mongoose'
Schema   = services.Schema
ObjectId = Schema.ObjectId

#define obj
obj = 
  id       : ObjectId
  username : 
    type : String
    set  : toLower
    validate: [
      validator
      '最小位数 >= 5; 最大位数 <= 10'
    ]
  alias    : String
  password : 
    type : String
    validate: [
      validator
      '最小位数 >= 5; 最大位数 <= 10'
    ]
  email    : String
  role     : 
    type    : String
    default : 'admin'
  cdate : 
    type    : Date
    default : Date.now 
  mdate : 
    type    : Date
    default : Date.now 

#export AdminSchema
exports.AdminsSchema = new Schema obj

#export obj2json
exports.obj2json = ( obj ) ->
  json = 
    id : obj.id
    username : obj.username
    alias : obj.alias
    password : obj.password
    email : obj.email
    role : obj.role
    cdate : obj.cdate
    mdate : obj.mdate

`
/**
 * to lower
 */
function toLower ( value ) {
  return value.toLowerCase();
}

/**
 * validator 5 >= x <= 10
 */
function validator ( value ) {
  return value.length >= 5 && value.length <= 10;
}
`