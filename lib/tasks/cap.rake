#encoding: utf-8

namespace :cap do

  require 'nokogiri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  task :fetch => :environment do
  	ROOT_URL = "http://www.nonsolocap.it"
  	regions_menu = openUrl(ROOT_URL + "/abruzzo/").css("ul.mg li")
  	regions_menu.each do |m|

  		puts m.text
  		region_page = openUrl(ROOT_URL + m.css("a").attr("href"))
  		region_info = region_page.css("td.oz")
  		region_info.each do |info|
  			if info.text == "Presidente"
  				puts "\t Presidente => " + info.next_element.text
  			elsif info.text == "Popolazione"
  				puts "\t Popolazione => " + info.next_element.text.split(" ")[0]
  			elsif info.text == "Densità"
  				puts "\t Densità => " + info.next_element.text.split(" ")[0]
  			elsif info.text == "Superficie"
  				puts "\t Superficie => " + info.next_element.text.split(" ")[0]
  			end 
  		end

  		#puts m.text + "(" + getRegion(m.text).id.to_s + ")" + " => " + m.css("a").attr("href")
  	end

  end


  def getRegion encodedName
		
		if encodedName == "Trentino-Alto Adige"
  		return Region.where(:name => "Trentino Alto Adige").first
  	elsif encodedName == "Emilia-Romagna"
  		return Region.where(:name => "Emilia Romagna").first
  	elsif encodedName == "Friuli-Venezia Giulia"
  		return Region.where(:name => "Friuli Venezia Giulia").first
  	else
  		return Region.where(:name => encodedName).first
  	end

  end

end