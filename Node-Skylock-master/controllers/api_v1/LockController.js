var mongoose = require('mongoose')
, User = require('../../models/User.js')
, Bike = require('../../models/Bike.js')
, Lock = require('../../models/Lock.js')
, ErrorServices = require("../../services/ErrorServices.js");

module.exports = LockController;

function LockController() {
}

LockController.prototype = {
	locks: function (req, res) {

		var access_token = req.get("x-app-token");

		if(access_token == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
		}

		User.findOne({ AccessToken : access_token }, function (err, _user){
			if (err) { return done(err); }

			if (_user == null) { 
				res.send(ErrorServices.UserErrors("UserDoesNotExists"));
			}else{
				Lock.find({ UserId : _user._id}, function (err, _lock){
					if (err) { return done(err); }

					res.send(_lock);
				});
			}
		});
	},

	addLock: function (req, res) {

		var access_token = req.get("x-app-token");

		if(access_token == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
		}

		User.findOne({ AccessToken : access_token }, function (err, _user){
			if (err) { return done(err); }

			if (_user == null) { 
				res.send(ErrorServices.UserErrors("UserDoesNotExists"));
			}else{
				new_lock = new Lock ({
					Name : req.body.name,
					UserId : _user._id
				});

				new_lock.save(function (err) {if (err) console.log (err)});
				res.send({ status : "1"});
			}
		});
	},

	deleteLock: function(req, res){
		var lock_id = req.query.lock_id;
		var access_token = req.get("x-app-token");

		if(access_token == null || lock_id == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token or lock_id"));
		}else{

			User.findOne({ AccessToken : access_token }, function (err, _user){
				if (err) { return done(err); }

				if (_user == null) { 
					res.send(ErrorServices.UserErrors("UserDoesNotExists"));
				}else{

					Lock.findOne({ _id : lock_id }, function (err, _lock){
						if (err) { return done(err); }

						if (_lock == null) { 
							res.send(ErrorServices.LockErrors("LockDoesNotExists"));
						}else{
							_lock.remove();
							res.send({ status : "1"});
						}
					});		
				}
			});
		}
	}
}