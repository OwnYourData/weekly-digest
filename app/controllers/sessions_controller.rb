class SessionsController < ApplicationController
	include ApplicationHelper
    include SessionsHelper

    def create
        user = User.find_by(email: params[:email].downcase)
        if user && user.authenticate(params[:password])
            log_in user
            redirect_to root_url
        else
            flash[:danger] = 'Invalid email/password combination'
            redirect_to login_url
        end
    end

    def change
        user = User.find(current_user)
        if user && user.authenticate(params[:old_password])
            if params[:password] == params[:confirm_password]
                user.update_attributes(password: params[:password])
                redirect_to root_url
            else
                flash[:danger] = 'New passwords don’t match'
                redirect_to change_pwd_url
            end
        else
            flash[:danger] = 'Invalid old password'
            redirect_to change_pwd_url
        end
    end

	def destroy
        log_out if logged_in?
        log_out if logged_in?
		redirect_to root_url
	end
end
