class Person < ApplicationRecord
	belongs_to :location
	belongs_to :affiliation
	
	validates_presence_of :first_name #, :last_name
	validates_inclusion_of :gender, :in =>["Male", "Female", "Other"]


  def self.search(search)
      where('first_name LIKE ?', "%#{search}%")
  end
end
