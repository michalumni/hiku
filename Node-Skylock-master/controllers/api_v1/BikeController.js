var mongoose = require('mongoose')
, User = require('../../models/User.js')
, Bike = require('../../models/Bike.js')
, ErrorServices = require("../../services/ErrorServices.js");

module.exports = BikeController;

function BikeController() {
}

BikeController.prototype = {
	bikes: function (req, res) {

		var access_token = req.get("x-app-token");

		if(access_token == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
		}

		User.findOne({ AccessToken : access_token }, function (err, _user){
			if (err) { return done(err); }

			if (_user == null) { 
				res.send(ErrorServices.UserErrors("UserDoesNotExists"));
			}else{
				Bike.find({ UserId : _user._id}, function (err, _bikes){
					if (err) { return done(err); }
					res.send(_bikes);
				});
			}
		});

	},
	addBike: function (req, res) {

		var access_token = req.get("x-app-token");

		if(access_token == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
		}else{
			User.findOne({ AccessToken : access_token }, function (err, _user){
				if (err) { return done(err); }
				if (_user != null) { 

					var new_bike = new Bike ({
						Name : req.body.name,
						PictureUrl : req.body.picture_url,
						BrandName : req.body.brand,
						Frame : req.body.frame,
						Model : req.body.model,
						Color : req.body.color,
						NumberOfSpeeds : req.body.speeds,
						SerialNumber : req.body.serial_number,
						DateOfPurchase : req.body.date_of_purchase,
						Note : req.body.note,
						UserId : _user._id
					});

					new_bike.save(function (err) {if (err) console.log (err)});
					res.send({ status : "1"});
				}else{
					res.send(ErrorServices.UserErrors("UserDoesNotExists"));
				}
			});
		}
	},

	deleteBike: function(req, res){
		var bike_id = req.query.bike_id;
		var access_token = req.get("x-app-token");

		if(access_token == null || bike_id == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token or bike_id"));
		}else{

			User.findOne({ AccessToken : access_token }, function (err, _user){
				if (err) { return done(err); }

				if (_user == null) { 
					res.send(ErrorServices.UserErrors("UserDoesNotExists"));
				}else{

					Bike.findOne({ _id : bike_id }, function (err, _bike){
						if (err) { return done(err); }

						if (_lock == null) { 
							res.send(ErrorServices.BikeErrors("BikeDoesNotExists"));
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


