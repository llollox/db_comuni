#encoding: utf-8

namespace :provinces do

  require 'nokogiri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  task :fetch => [:fetch_info_from_tuttaitalia, :addInfoManually]

	desc "Fetch some information about this province"
  task :fetch_info_from_tuttaitalia => :environment do
    provinces_links.each do |province_links|
      province_url = province_links.attr("href")
      province_page = openUrl(@@TUTTITALIA_URL + province_url)

      province_name = parse_province_name(province_page.css("h1.ev").first.text)
      puts "Name => " + province_name
      
      province = extractItem("Province", province_name)
      province.name = province_name
      
      region_name = province_page.css("table.uj td.oz").first.next_element.text
      puts "\t Region => " + region_name
      region = findItemByName("Region", region_name)
      province.region_id = region.id

      parseGeneralInfo(province_page, province)

      symbol_img = province_page.css("table.uj img")
      if symbol_img != nil && !symbol_img.empty?
        symbol_url = symbol_img.attr("src").text
        puts "\t Symbol => " + symbol_url
        addSymbol(province, symbol_url)
      end

      province.save

      puts "\n"

    end
  end

  def parse_province_name text
    if text.match(/Provincia di /)
      return text.split("Provincia di ")[1]
    elsif text.match(/Provincia del /)
      return text.split("Provincia del ")[1]
    elsif text.match(/Provincia dell'/)
      return "L'" + text.split("Provincia dell'")[1]
    elsif text.match(/Provincia della/)
      return "La " + text.split("Provincia della ")[1]
    elsif text.match(/Provincia autonoma di /)
      return text.split("Provincia autonoma di ")[1]
    end
  end

  task :addInfoManually => :environment do
    trento = Province.where(:name => "Trento").first
    trento.president = "Ugo Rossi"
    trento.save
    
    # Aosta email? website? president?
  end
end