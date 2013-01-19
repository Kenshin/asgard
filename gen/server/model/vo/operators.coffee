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
      usernamevalid
      '最小位数 >= 2; 最大位数 <= 10'
    ]
  alias    : String
  password : 
    type : String
    validate: [
      passwordvalid
      '最小位数 >= 1; 最大位数 <= 10'
    ]
  email    : String
  role     : 
    type    : String
    default : 'operator'
  cdate : 
    type    : Date
    default : Date.now 
  mdate : 
    type    : Date
    default : Date.now 

#export AdminSchema
exports.OperatorsSchema = new Schema obj

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
 * validator 2 >= x <= 10
 */
function usernamevalid ( value ) {
  return value.length >= 2 && value.length <= 10;
}

/**
 * validator 1 >= x <= 10
 */
function passwordvalid ( value ) {
  return value.length >= 1 && value.length <= 10;
}
`