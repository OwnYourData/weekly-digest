module ApplicationHelper
    require 'google/apis/calendar_v3'
    require 'googleauth'
    require 'googleauth/stores/file_token_store'

	def view_mode
		if params[:mode].to_s == ""
            if params[:view].to_s == ""
                ""
            else
                "?view=" + params[:view].to_s
            end
		else
            if params[:view].to_s == ""
                "?mode=" + params[:mode].to_s
            else
                "?mode=" + params[:mode].to_s + "&view=" + params[:view].to_s
            end
		end
	end

    def authorize
        client_id = Google::Auth::ClientId.new(
            ENV['CALENDAR_KEY'].to_s, 
            ENV['CALENDAR_SECRET'].to_s)
        token_store = Google::Auth::Stores::FileTokenStore.new(file: 'token.yaml')
        authorizer = Google::Auth::UserAuthorizer.new(
            client_id, 
            Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY, 
            token_store)
        user_id = 'default'
        credentials = authorizer.get_credentials(user_id) rescue nil
        if credentials.nil?
            code = ENV['CALENDAR_CODE'].to_s
            credentials = authorizer.get_and_store_credentials_from_code(
                user_id: user_id, 
                code: code, 
                base_url: 'urn:ietf:wg:oauth:2.0:oob') rescue nil
        end
        credentials
    end
    
    def ordinalize_number number, my_locale
        case my_locale.to_s
        when "en"
            return number.ordinalize
        else
            return number
        end
    end    

end
