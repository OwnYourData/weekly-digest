desc "Remove unconfirmed subscriptions"
task :remove_unconfirmed => :environment do
	Subscription.where(confirmed: false).where("created_at < ?", Date.today-3.days).destroy_all
end