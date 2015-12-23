class User < ActiveRecord::Base
	establish_connection :students_1415
	has_many :reviews, dependent: :destroy
end
