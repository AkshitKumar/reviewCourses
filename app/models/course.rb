class Course < ActiveRecord::Base
	has_many :reviews

	validates :name, :number , :prof , :credits , presence: true
end
