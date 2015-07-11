var mongoose = require('mongoose')
, Schema = mongoose.Schema;

var UserSchema = new Schema({
	Email : { type: String, trim: true}
	, FirstName : { type: String, trim: true }
	, LastName : { type: String, trim: true }
	, FacebookId : String
	, Password : String
	, PasswordSalt : String
	, PictureUrl : String
	, Phone : String
	, Birth : Date 
	, Gender : String 
	, AccessToken : String
	, GuidPasswordChange : String
});

module.exports = mongoose.model('UserModels', UserSchema);