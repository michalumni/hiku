var mongoose = require('mongoose')
, Schema = mongoose.Schema;

var LockSchema = new Schema({
	Name : { type: String, trim: true },
	UserId : { type: String }
});

module.exports = mongoose.model('LockModels', LockSchema);