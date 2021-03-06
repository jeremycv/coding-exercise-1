class PersonsController < ApplicationController

	helper_method :sort_column, :sort_direction
	def index
		@persons = Person.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page], per_page: 10)
		@locations = Location.all
		@affiliations = Affiliation.all
	end

	private

	def sort_column
    	Person.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
	end
  
	def sort_direction
		%w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
	end
end
