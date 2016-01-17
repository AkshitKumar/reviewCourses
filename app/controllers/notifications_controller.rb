class NotificationsController < ApplicationController
	before_action :authenticate_user!
    before_action :mark_as_read

	def index
		@notifs = current_user.notifications.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
	end

    def mark_as_read
        @unread = current_user.notifications.where(read: false)
        @unread.each do |unread|
            unread.update_attribute(:read, true)
        end
    end

    def authenticate_user!
      unless logged_in?
        redirect_to url_for(:controller=>'oauth',:action=>'index'), alert: "You need to sign in before continuing."
      end
    end

end
