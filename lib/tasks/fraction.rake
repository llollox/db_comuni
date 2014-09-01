#encoding: utf-8

namespace :fractions do

  require 'nokogiri'
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities
  require 'i18n'

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

  task :set_region_ids => :environment do
    Fraction.all.each_with_index do |fraction, index|
      if fraction.region_id.nil?
        fraction.region_id = fraction.municipality.region_id
        fraction.save
        puts "[" + index.to_s + "] " + fraction.name
      end
    end
  end

  task :fetch => :environment do
    ROOT_URL = "http://italia.indettaglio.it/ita/comuni/comuni_"
    empty_letters = ['k','w','y','x']
    
    ('r'..'z').to_a.each do |letter|
      if !empty_letters.include?(letter)
        municipalities_page = openUrl(ROOT_URL + letter + ".html")
        municipalities_select = municipalities_page.css("select[name='place']").first
        municipalities_select.css("option").each do |municipality_name|

          if !municipality_name.text.downcase.match(/selezionare|mappano/) 
            splitted = municipality_name.text.split(" (")
            municipality_name = splitted[0]
            region_name = splitted[1][0...-1]
            region = findItemByName("Region",region_name)
            municipality = getMunicipality(municipality_name, region.id)

            municipality_url = "http://italia.indettaglio.it/ita/" + 
              encode(region.name) + "/" + prepareForUrl(municipality.name) + ".html"

            puts municipality.name + " - " + region.name + " => " + municipality_url
            
            municipality_page = openUrl(municipality_url)
            
            if !municipality_page.nil? && municipality.fractions.empty?
              municipality_page.css("p").each do |p|
                if p.text.match(/anche le frazioni di/)
                  parseMultipleFractions(p.text,municipality)
                elsif p.text.match(/anche la frazione di/)
                  parseSingleFraction(p.text,municipality)
                elsif p.text.match(/non ha frazioni/)
                  puts "\t No fractions for this municipality!"
                end
              end

              municipality.save
              puts "\n"
            end

          end
        end
      end
    end

  end

  def addFraction municipality, fraction_name
    f = Fraction.new
    f.name = fraction_name
    municipality.fractions << f
  end

  def prepareForUrl municipality_name
    municipality_name = I18n.transliterate(municipality_name)
    return encode(municipality_name)
  end

  def parseMultipleFractions fractions, municipality
    fractions = fractions.split("anche le frazioni di")[1]
    reg = /(\D-- km\D)|(\D[0-9]+,[0-9]{2} km\D)/
    fractions = fractions.gsub(reg,"").split(",")
    fractions.each do |fraction|
      fraction_name = parseFractionName(fraction)
      addFraction(municipality, fraction_name)
      puts "\t" + fraction_name
    end
  end

  def parseSingleFraction fractions, municipality
    fraction = fractions.split("anche la frazione di")[1]
    fraction = fraction.split("che dista")[0]
    fraction_name = parseFractionName(fraction)
    addFraction(municipality, fraction_name)
    puts "\t" + fraction_name
  end

  def parseFractionName name
    name = name.gsub(".","")
    return name.strip
  end


  def getMunicipality name, region_id
    Municipality.all.each do |item|
      if encode(item.name) == encode(name) && region_id == item.province.region.id
        return item
      end
    end

    if name == "Brenzone"
      return findItemByName("Municipality","brenzone sul garda")
    elsif name == "Tremosine"
      return findItemByName("Municipality","tremosine sul garda")
    end 

    return nil
  end

end