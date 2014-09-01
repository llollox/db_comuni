namespace :db do

  require 'nokogiri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  task :set_name_encoded => :environment do
    
    ["Region","Province","Municipality","Fraction"].each do |class_name|
      puts "******************************************************"
      puts "Set name encoded for: #{class_name.upcase}"
      puts "******************************************************"
      class_name.constantize.all.each_with_index do |item, index|
        item.name_encoded = encode(item.name)
        item.save
        puts "[#{index}] " + item.name
      end
    end

  end

  task :set_photo_url => :environment do
    ["Region","Province","Municipality"].each_with_index do |class_name|
      puts "******************************************************"
      puts "Set photo url for: #{class_name.upcase}"
      puts "******************************************************"
      class_name.constantize.all.each_with_index do |item, index| 
        if !item.symbol.blank?
          if item.symbol.photo_url.blank?
            item.symbol.photo_url = item.symbol.photo.url
            item.symbol.save
          end
        end
        puts "[#{index}] #{item.name}"
      end
    end

  end 

end