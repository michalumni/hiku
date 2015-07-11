var mongoose = require('mongoose')
, User = require('../../models/User.js')
, Bike = require('../../models/Bike.js')
, Lock = require('../../models/Lock.js')
, hash = require('../../Helpers/Password.js').hash
, crypto = require('crypto')
, FB = require('fb')
, hat = require('hat')
, nodemailer = require("nodemailer")
, UserServices = require("../../services/UserServices.js")
, ErrorServices = require("../../services/ErrorServices.js");


module.exports = AccountController;

function AccountController() {
}

AccountController.prototype = {
	facebook_login: function (req, res) {

		var facebook_access_token = req.body.facebook_access_token;

		if(facebook_access_token != null){

			FB.setAccessToken(facebook_access_token);
			FB.api('me', { fields: ['email', 'id'] }, function (res_fb) {

				if(!res || res.error) {
					console.log(!res ? 'error occurred' : res.error);
					return;
				}
				User.findOne({ Email: res_fb.email }, function(err, _user) {
					if (err) { return console.log(err); }

					if(_user != null){
						var access_token = hat();
						res.header('X-App-Token', access_token);

						_user.AccessToken = access_token;
						_user.save(function (err) {if (err) console.log (err)});

						res.send(UserServices.getProfile(_user));
					}else{
						res.send(ErrorServices.UserErrors("FacebookUserDoesNotExists"));
					}

				});
			});
		}else{
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","facebook_access_token"));
		}
	},

	login: function (req, res) {
		var email = req.body.email;
		var password = req.body.password;

		if(email != null && password != null){
			authenticate(email, password, function(err, _user){ 
				if (_user != null) {     
					var access_token = hat();
					res.header('X-App-Token', access_token);
					
					_user.AccessToken = access_token;
					_user.save(function (err) {if (err) console.log (err)});
					
					res.send(UserServices.getProfile(_user));   
				}else{
					console.log(err);
					res.send(ErrorServices.DefaultErrors("CustomError",err));
				}
			});
		}else{
			console.log("Asdasd-");
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","email or password"));
		}
	},

	logout: function (req, res) {
		
		var access_token = req.get("x-app-token");

		if(access_token == null){
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
		}

		User.findOne({ AccessToken : access_token }, function (err, _user){
			if (err) { return done(err); }

			if (_user == null) { 
				res.send(ErrorServices.UserErrors("UserDoesNotExists"));
			}else{
				_user.AccessToken = "";
				_user.save(function (err) {if (err) console.log (err)});
				res.send({ status : 1});
			}
		});
	},

	change_password: function(req, res){
		
		var guid = req.query.guid;

		var smtpTransport = nodemailer.createTransport("SMTP",{
			service: "Gmail",
			auth: {
				user: "jan.ther@ulikeit.com",
				pass: "kolombo."
			}
		});

		User.findOne({ GuidPasswordChange : guid }, function (err, _user){
			if (err) { return done(err); }

			if (_user != null) { 

				var newpassword = hat().substring(1,7);

				hash(newpassword, function(err, salt, hash){   

					smtpTransport.sendMail({
					   from: "jan.ther@ulikeit.com", // sender address
					   to: _user.Email, 
					   subject: "Reset your Skylock password", // Subject line
					   text: "Dear " + _user.FirstName + ", \n" 
					   +"Here is your new password: " + newpassword + ""
					});

					_user.PasswordSalt = salt;
					_user.Password = hash;
					_user.GuidPasswordChange = "";

					_user.save(function (err) {if (err) console.log (err)});
					res.send({ status : 1});

				});

			}else{
				res.send(ErrorServices.UserErrors("UserDoesNotExists"));
			}
		})
	},

	forgot_password: function (req, res) {
		
		var email = req.body.email;

		var smtpTransport = nodemailer.createTransport("SMTP",{
			service: "Gmail",
			auth: {
				user: "jan.ther@ulikeit.com",
				pass: "kolombo."
			}
		});

		User.findOne({ Email : email }, function (err, _user){
			if (err) { return done(err); }

			if (_user != null) { 

				var guid = hat();

				smtpTransport.sendMail({
					   from: "jan.ther@ulikeit.com", // sender address
					   to: email, 
					   subject: "Reset your Skylock password", // Subject line
					   text: "Do you forgot your Skylock Account password? No problem - it happens to the best of us! \n\n"
					   +"Click the link below to reset your password."
					  // +"http://skylock-development.azurewebsites.net/password?guid="+guid
					  +"http://skylock-development.azurewebsites.net/password?guid="+guid
					});

				_user.GuidPasswordChange = guid;

				_user.save(function (err) {if (err) console.log (err)});
				res.send({ status : 1});

			}else{
				res.send(ErrorServices.UserErrors("UserDoesNotExists"));
			}
		})
	},

	facebook_signup: function (req, res) {
		var facebook_access_token = req.body.facebook_access_token;
		
		if(facebook_access_token != null){
			FB.setAccessToken(facebook_access_token);

			FB.api("me", { fields: ['id', 'first_name', 'email', 'last_name', 'birthday', 'gender', 'picture.height(200)'] }, function (res_fb) {

				if(!res_fb || res_fb.error) {
					console.log(!res_fb ? 'error occurred' : res_fb.error);
					return;
				}

				User.findOne({ Email: res_fb.email }, function(err, _user) {
					if (err) { return done(err); }
					if (!_user) { 

						var access_token = hat();
						var new_user = new User ({
							FirstName:  res_fb.first_name,
							LastName:  res_fb.last_name,
							Email:  res_fb.email,
							FacebookId:  res_fb.id,
							PictureUrl : res_fb.picture.data.url,
							Phone : "",
							Birth : res_fb.birthday,
							Gender : res_fb.gender,
							AccessToken : access_token
						});
						new_user.save(function (err) {if (err) console.log (err)});

						res.header('X-App-Token', access_token);
						res.send(UserServices.getProfile(new_user));
					}else {
						res.send(ErrorServices.UserErrors("UserAlreadyExists"));
					}
				});
			});
		}else{
			res.send(ErrorServices.DefaultErrors("ObjectsEmpty","access_token"));
		}
	},

	signup: function (req, res) {
		var email = req.body.email;
		var password = req.body.password;
		var phone = req.body.phone;
		var birth = req.body.birth;
		var firstName = req.body.first_name;
		var lastName = req.body.last_name;
		var gender = req.body.gender;

		if(password == null){
			var password = hat();
		}
		
		if(email != "undefined"){

			User.findOne({ Email: email }, function(err, _user) {
				if (err) { return done(err); }
				if (!_user) { 

					hash(password, function(err, salt, hash){   
						if (err) return console.log(err);

						var access_token = hat();
						var new_user = new User();

						new_user.Password =  hash.toString();
						new_user.PasswordSalt = salt;
						new_user.FirstName =  firstName;
						new_user.LastName =  lastName;
						new_user.Email =  email;
						new_user.Phone = phone;
						new_user.Gender = gender;
						new_user.Birth = new Date(birth);
						new_user.FacebookId = "";
						new_user.AccessToken = access_token;

						new_user.save(function (err) {if (err) console.log ('Error on save!')});

						res.header('X-App-Token', access_token);
						res.send(UserServices.getProfile(new_user));
					});
				}else{
					res.send(ErrorServices.UserErrors("UserAlreadyExists"));
				}
			});
}else{
	res.send(ErrorServices.DefaultErrors("ObjectsEmpty","password or email"));
}

}
}

function authenticate(email, pass, fn) {                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
	User.findOne({ Email: email }, function(err, _user) {
		if (err)  return fn(new Error('cannot find user'));    

		if (_user != null) {
			hash(pass, _user.PasswordSalt, function(err, hash){
				if (err) return fn(err);
				if (hash.toString() == _user.Password) return fn(null, _user);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
				fn("invalid password",null);          
			});
		}else{
			return fn("invalid email", null);
		}
	});
}   
