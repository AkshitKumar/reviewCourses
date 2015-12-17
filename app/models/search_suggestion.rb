class SearchSuggestion < ActiveRecord::Base
	# attr_accessible :term, :popularity

	def self.terms_for(prefix)
		# Rails.cache.fetch(["search-terms", prefix]) do
			suggestions = where("LOWER(term) LIKE ?", "%#{prefix}%")
			# suggestions.order("popularity desc").pluck(:term)
		# end
	end

	def self.index_courses
		Course.find_each do |course|
			index_name(course.name,course.id)
			index_prof(course.prof)
			# course.name.split.each { |t| index_term(t) }
			# course.prof.split.each { |t| index_term(t) }
		end
	end

	def self.index_name(term,id)
		where(term: term).first_or_initialize.tap do |suggestion|
			suggestion.term_type = "Course"
			suggestion.course_id = id
			suggestion.increment! :popularity
		end
	end

	def self.index_prof(term)
		where(term: term).first_or_initialize.tap do |suggestion|
			suggestion.term_type = "Professor"
			suggestion.increment! :popularity
		end
	end
end
