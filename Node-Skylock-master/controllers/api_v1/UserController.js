var mongoose = require('mongoose')
, User = require('../../models/User.js')
, Bike = require('../../models/Bike.js')
, hash = require('../../Helpers/Password.js').hash
, Lock = require('../../models/Lock.js')
, azure = require('azure')
, multiparty = require('multiparty')
, async = require('async')
, fs = require('fs')
, hat = require('hat')
, UserServices = require("../../services/UserServices.js")
, ErrorServices = require("../../services/ErrorServices.js")
, formidable          = require( "formidable" )
, util = require('util');

var formidable = require('formidable');

module.exports = UserController;

function UserController() {
}

UserController.prototype = {

	profile: function (req, res) {
		var access_token = req.get("x-app-token");
		if(access_token == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
		}else{

			User.findOne({ AccessToken : access_token }, function (err, _user){
				if (err) { return done(err); }

				if (_user != null) { 
					res.send(UserServices.getProfile(_user));
				}else{
					res.send(ErrorServices.UserErrors("UserDoesNotExists"));
				}
			})
		}
	},

	update: function(req, res){
		var access_token = req.get("x-app-token");
		if(access_token == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
		}else{

			var oldPassword = req.body.old_password;
			var newPassword = req.body.new_password;

			User.findOne({ AccessToken : access_token }, function (err, _user){
				if (err) { return done(err); }

				if (_user != null) { 

					if(newPassword != null && oldPassword != null){

						hash(oldPassword, _user.PasswordSalt, function(err, _hash){

							if (_hash.toString() == _user.Password){

								hash(newPassword, function(err, salt, hash){   

									_user.LastName = req.body.last_name;
									_user.Phone = req.body.phone;
									_user.Birth = req.body.birth;
									_user.Gender = req.body.gender;
									_user.Password = hash;
									_user.PasswordSalt = salt;

									_user.save(function (err) {if (err) console.log (err)});

									res.send(UserServices.getProfile(_user));
								})
							}else{
								res.send(ErrorServices.UserErrors("BadPassword"));
							}   
						});
					}else {
						_user.FirstName =  req.body.first_name;
						_user.LastName = req.body.last_name;
						_user.Phone = req.body.phone;
						_user.Birth = req.body.birth;
						_user.Gender = req.body.gender;

						_user.save(function (err) {if (err) console.log (err)});

						res.send(UserServices.getProfile(_user));
					}
				}else{
					res.send(ErrorServices.UserErrors("UserDoesNotExists"));
				}
			})}
},

avatar: function (req, res) {
	var access_token = req.get("x-app-token");

	if(access_token == null){
		res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
	} else {
		User.findOne({ AccessToken : access_token }, function (err, _user){


			if (err) { return done(err); }

			if (_user != null) {

				var container = 'avatar-pictures';

				var blobService = azure.createBlobService('ordrdevelopment', 'G2tOImBWwTmk+WlKlVNn8tcxDjKeNZ9e6jMy8c7j6GlQVUOvubkBNLtnkOtS1lAjpCdc8GvFsRvUA4XujQb5IQ==');

				var type = req.files.avatar.type;
				var filename = hat() + req.files.avatar.name;
				var path = req.files.avatar.path;


				var options = {
					contentType: type,
					metadata: { fileName: filename }
				}

				async.series({
					block: function(callback) {
						blobService.createBlockBlobFromFile(container, filename, path, options,callback);

					},
					unlink: function(callback) {
						fs.unlink(path, callback);
					}
				}, function(err, results) {


				});

				var url = "http://ordrdevelopment.blob.core.windows.net/avatar-pictures/" + filename;
				_user.PictureUrl = url;
				_user.save(function (err) {if (err) console.log ('Error on save!')});

				res.send({ avatar_url : url});

			}else{
				res.send(ErrorServices.UserErrors("UserDoesNotExists"));
			}
		})}
},

all_users: function (req, res) {
	User.find(function (err, items) {
		res.send(items);
	});
}
}

