#encoding: utf-8

namespace :regions do

  require 'nokogiri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  task :set_name_encoded => :environment do
    Region.all.each_with_index do |region_name, index|
      region_name.name_encoded = encode(region_name.name)
      region_name.save
      puts "[#{index}] " + region_name.name
    end
  end 

  desc "Fetch some information about this region"
  task :fetch => :environment do

    regions_links.each_with_index do |region_link, index|

      region_page = openUrl(@@TUTTITALIA_URL + region_link.attr("href"))

      region_name = region_page.css("h1.ev").text.split("/")[0]
      puts (index + 1).to_s + ") " + region_name
      
      region = extractItem("Region", region_name)

      parseGeneralInfo(region_page, region)

      symbol_url = region_page.css("table.uj img").attr("src").text
      puts "\t Symbol => " + symbol_url
      addSymbol(region, symbol_url)

      region.save

      puts "\n"

    end

  end

  task :fetch_symbols => :environment do
    regions_links.each_with_index do |region_link, index|
      region_page = openUrl(@@TUTTITALIA_URL + region_link.attr("href"))
      symbol_url = region_page.css("table.uj img").attr("src").text

      region_name = region_page.css("h1.ev").text.split("/")[0]
      region = extractItem("Region", region_name)

      addDropboxSymbol(region,symbol_url)

      region.save
      puts "[#{index}] " + region.name
    end
  end

  task :fetch_capitals => :environment do
    regions_links.each_with_index do |region_link, index|

      region_page = openUrl(@@TUTTITALIA_URL + region_link.attr("href"))
      region_name = region_page.css("h1.ev").text.split("/")[0]

      region = findItemByName("Region", region_name)
      puts (index + 1).to_s + ") " + region.name

      region_page.css("table.uj td").each do |info|

        if info.text == "Capoluogo"
          capital_link = info.next_element.css("a").first
          capital_name = capital_link.text
          capital_url = @@TUTTITALIA_URL + region_link.attr("href") + capital_link.attr("href")
          
          capital_page = openUrl(capital_url)

          # Extract Municipality
          province_abbreviation = capital_page.css("table.uj td").first.
            next_element.text.match(/[A-Z]{2}/).to_s
          province = Province.where(:abbreviation => province_abbreviation).first
          puts "\t Province => " + province.name

          # Extract Capital
          capital = findMunicipalityByName(province.id, capital_name)
          puts "\t Capital => " + capital.name
          
          # Save Capital  
          region.capital_id = capital.id
          region.save
        
        end
      end

      puts "\n"

    end
  end

end