class Fraction < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :name, :municipality_id, :region_id

  belongs_to :municipality
  belongs_to :region

  # before_save :update_name_encoded

 #  geocoded_by :address
	# after_validation :geocode

 #  def address
 #    address = self.name
 #    address += ", " + self.province.name
 #    address += ", " + self.province.abbreviation
 #    address += ", " + self.caps.first.number if !self.caps.empty?
 #    address += ", " + self.province.region.name
 #    address += ", Italy"
 #    return address
 #  end

  def province
    self.municipality.province
  end

  # def self.encode name
  #   name = name.split("/").first if name.match(/\//)
  #   name = name.split("\\").first if name.match(/\\/)
  #   name = name.split(" - ").first if name.match(/ - /)
  #   return name.gsub(/[^0-9A-Za-z]/, '').downcase
  # end

  # def update_name_encoded
  #   self.name_encoded = encode(self.name)
  # end
end
