class Fraction < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :name, :municipality_id, :region_id

  belongs_to :municipality
  belongs_to :region

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
end
