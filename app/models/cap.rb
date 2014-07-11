class Cap < ActiveRecord::Base
  attr_accessible :number
  belongs_to :municipality
end
