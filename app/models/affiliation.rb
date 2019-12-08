class Affiliation < ApplicationRecord
	has_many :persons

	validates_uniqueness_of :name
end
