class Course < ActiveRecord::Base
	has_many :reviews
	belongs_to :dept
	searchkick word_start: [:name]
	validates :name, :number , :prof , :credits , presence: true
	validates :name,:format => {:with => /\A[a-zA-Z]+\Z/}
	validates :number,length: { is: 6 },:format => {:with => /\A[a-zA-Z0-9]+\Z/}
	validates :prof,:format => {:with => /\A[\w]+\Z/}
	validates :credits,numericality: { only_integer: true }
	class << self
		def categorize(dept=nil, prof=nil, sem=nil)
    		return where(dept_id: dept, prof: prof, sem: sem) if dept && prof && sem
    		return where(dept_id: dept, prof: prof) if dept && prof
    		return where(sem: sem, prof: prof) if sem && prof
    		return where(dept_id: dept, sem: sem) if dept && sem
    		return where(dept_id: dept) if dept
    		return where(prof: prof) if prof
    		return where(sem: sem) if sem
    		all
		end
	end
end

def search_data
	as_json only: [:name, :prof, :number]
end