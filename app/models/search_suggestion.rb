class SearchSuggestion < ActiveRecord::Base
	# attr_accessible :term, :popularity

	def self.terms_for(prefix)
		suggestions = where("LOWER(term) LIKE ?", "%#{prefix}%")
	end

	def self.index_courses
		Course.find_each do |course|
			term = course.number+" "+course.name+" by "+course.prof
			index_name(term,course.name,course.id)
			# index_prof(course.prof)
			# course.name.split.each { |t| index_term(t) }
			# course.prof.split.each { |t| index_term(t) }
		end
	end

	def self.index_name(term,name,id)
		where(term: term).first_or_initialize.tap do |suggestion|
			suggestion.term_type = name
			suggestion.course_id = id
			suggestion.increment! :popularity
		end
	end

	# def self.index_prof(term)
	# 	where(term: term).first_or_initialize.tap do |suggestion|
	# 		suggestion.term_type = "Professor"
	# 		suggestion.increment! :popularity
	# 	end
	# end
end
