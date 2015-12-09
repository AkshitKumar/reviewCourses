class Course < ActiveRecord::Base
	has_many :reviews
	searchkick word_start: [:name]
	validates :name, :number , :prof , :credits , presence: true
end

def search_data
	as_json only: [:name, :prof, :number]
end