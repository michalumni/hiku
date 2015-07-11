
/**
 * Module dependencies.
 */

 var express = require('express');
 var routes = require('./routes');
 var http = require('http');
 var path = require('path');
 var mongoose = require('mongoose');

 var connection_string = 'mongodb://MongoDB-w:cBk4taj1IMCb68lnnB.PZe36aEHVZTQm8S.WhISnN8o-@ds030827.mongolab.com:30827/MongoDB-w';
 var url_prefix_version = "/api/v1";

 var app = express();

 mongoose.connect(connection_string);

 var User = require('./controllers/api_v1/UserController');
 var user = new User();

 var Account = require('./controllers/api_v1/AccountController');
 var account = new Account();

 var Bike = require('./controllers/api_v1/BikeController');
 var bike = new Bike();

 var Lock = require('./controllers/api_v1/LockController');
 var lock = new Lock();


// all environments
app.set('port', process.env.PORT || 3000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(express.bodyParser());
app.use(app.router);
app.use(require('stylus').middleware(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'public')));

// development only
if ('development' == app.get('env')) {
	app.use(express.errorHandler());
}

//Users
app.get(url_prefix_version + "/user/all", user.all_users.bind());
app.get(url_prefix_version + "/user/profile", user.profile.bind());
app.post(url_prefix_version + "/user/avatar", user.avatar.bind());
app.post(url_prefix_version + "/user/update", user.update.bind());

//Accounts
app.post(url_prefix_version + "/account/login", account.login.bind());
app.post(url_prefix_version + "/account/facebook-login", account.facebook_login.bind());
app.post(url_prefix_version + "/account/signup", account.signup.bind());
app.post(url_prefix_version + "/account/facebook-signup", account.facebook_signup.bind());
app.post(url_prefix_version + "/account/forgot-password", account.forgot_password.bind());
app.get(url_prefix_version + "/account/logout", account.logout.bind());
app.get("/password", account.change_password.bind());

//Bikes
app.post(url_prefix_version + "/bike/add-bike", bike.addBike.bind());
app.get(url_prefix_version + "/bike/bikes", bike.bikes.bind());
app.delete(url_prefix_version + "/bike", bike.deleteBike.bind());

//Locks
app.post(url_prefix_version + "/lock/add-lock", lock.addLock.bind());
app.get(url_prefix_version + "/lock/locks", lock.locks.bind());
app.delete(url_prefix_version + "/lock", lock.deleteLock.bind());


app.get('/test-file', function (req, res) {


	res.send('<form method="post" action="/api/v1/user/avatar" enctype="multipart/form-data">'
		+ '<p>Image: <input type="text" name="123" /></p>'
		+ '<p>Image: <input type="file" name="avatar" /></p>'
		+ '<p><input type="submit" value="Upload" /></p>'
		+ '</form>');

});


app.post('/', function(req, res, next){
  // the uploaded file can be found as `req.files.image` and the
  // title field as `req.body.title`

});



http.createServer(app).listen(app.get('port'), function(){
	console.log('Express server listening on port ' + app.get('port'));
});
