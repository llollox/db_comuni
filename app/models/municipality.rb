class Municipality < ActiveRecord::Base
  attr_accessible :name, :province_id,
  	:population, :density, :surface, :istat_code, :president,
  	:cadastral_code, :telephone_prefix, :email, :website, 
    :symbol, :latitude, :longitude
  
  belongs_to :province
  belongs_to :region
  has_many :caps
  has_many :fractions

  has_one :symbol, :class_name => "Picture", as: :picturable, dependent: :destroy

  geocoded_by :address
	after_validation :geocode

  def address
    address = self.name
    address += ", " + self.province.name
    address += ", " + self.province.abbreviation
    address += ", " + self.caps.first.number if !self.caps.empty?
    address += ", " + self.province.region.name
    address += ", Italy"
    return address
  end

  def region
    self.province.region
  end

end
