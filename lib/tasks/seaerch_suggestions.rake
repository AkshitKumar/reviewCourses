namespace :search_suggestions do 
	desc "Generate search suggestions from courses"
	task :index => :environment do
		SearchSuggestion.index_courses
	end	
end