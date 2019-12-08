class UploadController < ApplicationController

	
	def index
	
	end

	def import

		uploaded_file = params[:csv_file]
		csv_file_name = Rails.root.join('public', uploaded_file.original_filename.upcase)

		File.open( csv_file_name, 'wb') do |file|
    		file.write(uploaded_file.read)
  		end
  		if File.exists?(csv_file_name) && (csv_file_name.extname == ".CSV")

  			# Clear the required tables
			Person.all.each { |person| person.destroy }
			Location.all.each { |location| location.destroy }
			Affiliation.all.each { |affiliation| affiliation.destroy }

			require 'csv'
			CSV.open( csv_file_name, 'r').each do |person|
				full_name 	= person[0]
				location 	= person[1]
				species 	= person[2]
				gender 		= person[3]
				affiliation = person[4]
				weapon 		= person[5]
				vehicle 	= person[6]

				if !full_name.nil?
					full_name = full_name.gsub(/(\A|\s)\w/){ |letter| letter.upcase }
					first_name = full_name.split[0]
					last_name = full_name.sub(first_name, '')
				else
					full_name = ''
				end
				
				if !gender.nil?
					gender = gender.titleize
					gender = "Male" if gender[0] == "M"
					gender = "Female" if gender[0] == "F"
					gender = "Other" if !(gender == "Male" || gender == "Female")
				else
					gender = ''
				end

				if !location.nil?

					location = location.titleize
					location = location.split(', ')
					location.each do |this_location|

						existing_location = Location.find_by_name(this_location)
						if existing_location.nil?
							new_location = Location.new
							new_location.name = this_location
							new_location.save if this_location != "Location"
						end

						if !affiliation.nil?

							affiliation = affiliation.split(', ')
							affiliation.each do |this_affiliation|

								existing_affiliation = Affiliation.find_by_name(this_affiliation)
								if existing_affiliation.nil?
									new_affiliation = Affiliation.new
									new_affiliation.name = this_affiliation
									new_affiliation.save if this_affiliation != "Affiliations"
								end

								new_person = Person.new
								new_person.first_name = first_name
								new_person.last_name = last_name
								new_person.species = species
								new_person.gender = gender
								new_person.weapon = weapon
								new_person.vehicle = vehicle
								new_person.location_id = existing_location.nil? ? new_location.id : existing_location.id
								new_person.affiliation_id = existing_affiliation.nil? ? new_affiliation.id : existing_affiliation.id
								new_person.save if (first_name != "Name")
							end
						end
					end
				end
			end
			File.delete(csv_file_name) if File.exists?(csv_file_name)			
			flash[:alert] = "File successfully loaded!"
			redirect_to root_url
		end
	end
end
