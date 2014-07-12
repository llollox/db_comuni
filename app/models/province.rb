class Province < ActiveRecord::Base
  attr_accessible :abbreviation, :name, :region_id,
  	:population, :density, :surface, :symbol, 
    :president, :email, :website
  
  belongs_to :region
  has_many :municipalities
  has_one :symbol, :class_name => "Picture", as: :picturable, dependent: :destroy

  validates :name, presence: true

  def name_with_abbreviation
  	self.name + " (" + self.abbreviation + ")"
  end

end	
