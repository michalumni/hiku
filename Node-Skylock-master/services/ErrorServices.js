var method = ErrorServices.prototype;

function ErrorServices() {
}

UserEnum = {
	BadPassword : "BadPassword",
	UserDoesNotExists : "UserDoesNotExists",
	FacebookUserDoesNotExists : "FacebookUserDoesNotExists",
	UserAlreadyExists : "UserAlreadyExists"
}

DefaultEnum = {
	ObjectsEmpty : "ObjectsEmpty",
	CustomError : "CustomError"
}

BikeEnum = {
	BikeDoesNotExists : "BikeDoesNotExists"
}

LockEnum = {
	LockDoesNotExists : "LockDoesNotExists"
}


// CODE: 1000+
ErrorServices.UserErrors = function(ERROR) {
	switch(ERROR)
	{

		case UserEnum.UserAlreadyExists:
		return {error: {  message : "user already exists", code : 1001}}

		case UserEnum.BadPassword:
		return {error: {  message : "bad password", code : 1005}}

		case UserEnum.UserDoesNotExists:
		return {error: {  message : "user doesn't exist", code : 1002}}

		case UserEnum.FacebookUserDoesNotExists:
		return {error: {  message : "facebook user doesn't exist", code : 1003}}

		default:
		return {error: {  message : "Error", code : 1000}}
	}
};

// CODE: 2000+
ErrorServices.BikeErrors = function(ERROR) {
	switch(ERROR)
	{
		case BikeEnum.BikeDoesNotExists:
		return {error: {  message : "bike doesn't exist", code : 2001}}

		default:
		return {error: {  message : "Error", code : 2000}}
	}
};

// CODE: 3000+
ErrorServices.LockErrors = function(ERROR) {
	switch(ERROR)
	{
		case LockEnum.LockDoesNotExists:
		return {error: {  message : "lock doesn't exist", code : 3001}}

		default:
		return {error: {  message : "Error", code : 3000}}
	}
};

// CODE: 4000+
ErrorServices.DefaultErrors = function(ERROR, note) {
	switch(ERROR)
	{
		case DefaultEnum.ObjectsEmpty:
		return {error: {  message : "Some of the objects are empty : " + note, code : 4001}}

		case DefaultEnum.CustomError:
		return {error: {  message : note, code : 4002}}

		default:
		return {error: {  message : "Error", code : 4000}}
	}
};

module.exports = ErrorServices;