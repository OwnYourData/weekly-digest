module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id
	end

	def current_user
        if !session[:user_id].nil?
        	current_user = session[:user_id]
        else
        	current_user = nil
		end
	end

	def logged_in?
		!current_user.nil?
	end

	def log_out
		session.delete(:user_id)
		current_user = nil
	end

end
