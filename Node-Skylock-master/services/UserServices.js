var method = UserServices.prototype;

function UserServices() {
}

UserServices.getProfile = function(user) {
    if (user != null) { 
		return { 
			user_id : user._id,
			first_name : user.FirstName,
			last_name : user.LastName,
			birth : user.Birth != null ? (user.Birth.getMonth() + "/"+ user.Birth.getDate() +"/"+ user.Birth.getFullYear()) : "",
			last_name : user.LastName,
			gender : user.Gender,
			email : user.Email,
			phone : user.Phone,
			avatar_url : user.PictureUrl				
		};
	}else{
		return {error: {  message : "user doesn't exists", code : 1002}};
	}
};

module.exports = UserServices;