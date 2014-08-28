class Region < ActiveRecord::Base
  attr_accessible :name, :capital_id, :president, :population, 
  	:density, :surface, :abbreviation, :email, :website, :symbol

  # has_one :symbol, :class_name => "Picture", as: :picturable, dependent: :destroy
  has_one :dropbox_symbol, :class_name => "DropboxDbComuniPicture", as: :picturable, dependent: :destroy

  has_many :provinces
  has_many :municipalities
  has_many :fractions

  def capital
  	Municipality.find self.capital_id
  end

  def symbol
    self.dropbox_symbol
  end

end
