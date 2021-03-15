desc "Send out newsletter"
task :send_newsletter => :environment do
	Subscription.all.each do |item|
		WeeklyMailer.send_email(item.email).deliver_now
	end
end