var mongoose = require('mongoose')
, Schema = mongoose.Schema;

var BikeSchema = new Schema({
	Name : { type: String, trim: true}
	, PictureUrl : { type: String, trim: true }
	, BrandName : { type: String, trim: true }
	, Frame :  { type: String, trim: true }
	, Model :  { type: String, trim: true }
	, Color :  { type: String, trim: true }
	, NumberOfSpeeds : Number
	, SerialNumber : String
	, DateOfPurchase : Date 
	, Note :  { type: String, trim: true }
	, UserId : String
});

module.exports = mongoose.model('BikeModels', BikeSchema);