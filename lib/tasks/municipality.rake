#encoding: utf-8

namespace :municipalities do

  require 'nokogiri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  task :geocode => :environment do
    Region.all.each do |region|
      puts "*****************   " + region.name + "   *****************"
      region.provinces.all.each do |province|
        puts "\n " + province.name + " (" + province.abbreviation + ")"
        province.municipalities.each do |municipality|
          if municipality.latitude.nil? || municipality.longitude.nil?
            municipality.geocode
            municipality.save
            puts "\t " + municipality.name + ": [" + municipality.latitude.to_s + 
              ", " + municipality.longitude.to_s + "]"
          end
        end
      end
    end
  end

  task :fetch => [:fetch_info_from_tuttaitalia, :execute_manually_changes]

  task :fetch_info_from_tuttaitalia => :environment do

    municipalities_links[7560..-1].each do |municipality_link|

      municipality_page = openUrl(municipality_link)

      if municipality_page != nil 

        # Extract Province
        province_abbreviation = municipality_page.css("table.uj td").first.
          next_element.text.match(/[A-Z]{2}/).to_s
        province = Province.where(:abbreviation => province_abbreviation).first

        # Extract Municipality Name
        municipality_name = municipality_page.css("h1.ev").first.text

        # Extract Municipality Object
        municipality = extractMunicipality(province.id, municipality_name)
        
        # Assign Name and Province
        puts "Name => " + municipality_name
        municipality.name = municipality_name
        puts "\t Province => " + province.name
        municipality.province_id = province.id
        
        municipality_page.css("table.uj td").each do |info|

          if info.text == "Codice Istat"
            istat_code = info.next_element.text.strip
            puts "\t Codice Istat => " + istat_code
            municipality.istat_code = istat_code
          
          elsif info.text == "Codice catastale"
            cadastral_code = info.next_element.text.strip
            puts "\t Codice catastale => " + cadastral_code
            municipality.cadastral_code = cadastral_code
          
          elsif info.text == "Prefisso"
            telephone_prefix = info.next_element.css("a").text.strip
            puts "\t Prefisso => " + telephone_prefix
            municipality.telephone_prefix = telephone_prefix

          elsif municipality.caps.empty? && info.text == "CAP"
            caps_list = info.next_element.css("span.xa").text.scan(/\d{5}/)
            puts "\t CAP => " + caps_list.to_s
            if caps_list.size == 1
              addCap(municipality, caps_list[0])
            else
              caps_list[0].to_i.upto(caps_list[1].to_i){ |c|
                addCap(municipality, c)
              }
            end
          end
        end

        parseGeneralInfo(municipality_page, municipality)

        symbol_img = municipality_page.css("table.uj img")
        if !symbol_img.empty? # no img found
          puts "\t Symbol => " + symbol_img.attr("src").text
          symbol_url = symbol_img.attr("src").text
          addSymbol(municipality, symbol_url)
        else
          fetch_symbol_from_wikipedia(municipality)
        end

        municipality.save

        puts "\n"

      end

    end
  end

  def fetch_symbol_from_wikipedia municipality
    municipality_page = openUrl(URI.encode(@@WIKIPEDIA_URL + municipality.name.gsub(" ","_")))

    if municipality_page != nil
      img = municipality_page.css("table.sinottico a.image img")
          
      if img != nil && !img.empty?
        if img.attr("src").to_s.match(/Italy/)
          puts "\t Symbol => Image Not Found!"
        else
          symbol_url = "http:" + img.attr("src")
          puts "\t Symbol => " + symbol_url
          addSymbol(municipality, symbol_url)
        end
      end
    else
      puts "\t Symbol => Page Not Found!"
    end

  end

  def addCap municipality, cap
    c = Cap.new
    c.number = cap
    municipality.caps << c
  end

  task :execute_manually_changes => :environment do
    roma = Municipality.where(:name => "Roma Capitale").first
    if !roma.nil?
      roma.name = "Roma"
      roma.save
    end
  end

end