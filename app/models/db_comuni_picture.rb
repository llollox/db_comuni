class DbComuniPicture < ActiveRecord::Base
  attr_accessible :photo, :title, :photo_url
  belongs_to :picturable, polymorphic: true
  

  has_attached_file :photo, 
  :storage => :dropbox,
  :dropbox_credentials => Rails.root.join("config/dropbox.yml"),
  :path => "db_comuni_pictures/:style/:id_:filename",

  :styles => lambda { |a|
   if a.instance.is_pdf?
     { :thumb => ["100x100>", :jpg], :original => ["600x400>", :jpg]}
   else
     { :thumb => ["100x100>"], :original => ["600x400>"]}
   end
  },
    
  :processors => lambda { |a|
   if a.is_pdf?
     [:ghostscript, :thumbnail]
   else
     [:thumbnail]
   end
  },

  :convert_options => { :all => '-density 300 -quality 100' }

  # :default_url => ActionController::Base.helpers.asset_path('missing_:style.png')
     
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png','application/pdf','image/gif']

  def is_pdf?
     ["application/pdf"].include?(self.photo_content_type) 
  end
end
