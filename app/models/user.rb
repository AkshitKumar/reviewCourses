class User < ActiveRecord::Base
	establish_connection :students_1415
	has_many :reviews, dependent: :destroy
	has_many :notifications, dependent: :destroy
	has_many :votes, dependent: :destroy
end
