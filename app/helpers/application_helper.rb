module ApplicationHelper
	def view_mode
		if params[:mode].to_s == ""
			""
		else
			"?mode=" + params[:mode].to_s
		end
	end
end
