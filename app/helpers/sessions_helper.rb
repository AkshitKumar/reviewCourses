module SessionsHelper
	def log_in(user)
		session[:user_id] = user.id
		self.current_user = user
	end


	def current_user
		@current_user ||= User.find_by(id: session[:user_id])
	end
	def current_user=(user)
    	@current_user = user
  	end

	def logged_in?
		!current_user.nil?
	end
	def log_out
		session.delete(:user_id)
		@current_user = nil
	end
	def admin?
	#	user = current_user
	#	id = current_user.user_id
		id = session[:user_id]
		if Admin.find_by(adminid: id)
			!nil
		else
			false
		end
	end
end
