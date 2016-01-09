class NotificationsController < ApplicationController
	before_action :authenticate_user!
    before_action :mark_as_read

	def index
		@notifs = current_user.notifications.order("created_at desc")
	end

    def mark_as_read
        @unread = current_user.notifications.where(read: false)
        @unread.each do |unread|
            unread.update_attribute(:read, true)
        end
    end

    def authenticate_user!
      unless logged_in?
        redirect_to root_url, alert: "You need to sign in before continuing."
      end
    end

end
