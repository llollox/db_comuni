class Municipality < ActiveRecord::Base
  # include Searchable
  
  attr_accessible :name, :province_id, :region_id,
  	:population, :density, :surface, :istat_code, :president,
  	:cadastral_code, :telephone_prefix, :email, :website, 
    :symbol, :latitude, :longitude, :name_encoded

  # before_save :update_name_encoded

  belongs_to :province
  belongs_to :region
  has_many :caps
  has_many :fractions

  has_one :symbol, :class_name => "DbComuniPicture", as: :picturable, dependent: :destroy

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

  # def self.encode name
  #   name = name.split("/").first if name.match(/\//)
  #   name = name.split("\\").first if name.match(/\\/)
  #   name = name.split(" - ").first if name.match(/ - /)
  #   return name.gsub(/[^0-9A-Za-z]/, '').downcase
  # end

  # private

  # def update_name_encoded
  #   self.name_encoded = encode(self.name)
  # end
end
