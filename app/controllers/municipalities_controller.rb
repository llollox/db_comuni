class MunicipalitiesController < ApplicationController
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  before_filter :check_login, :only => [:delete, :create, :new, :update, :edit]


  def search

    region_id = encode(params[:region_id]) if params[:region_id]
    name = encode(params[:name]) if params[:name]

    if !region_id.nil?
      region = Region.find(region_id.to_i)

      region.municipalities.each do |municipality|
        if encode(municipality.name) == encode(name) && region_id.to_i == municipality.region_id
          @municipality = municipality 
          break
        end
      end
  
    else
      @municipality = findItemByName("Municipality", name)
    end

    respond_to do |format|
      format.json { render json: @municipality }
    end

  end

  # Optimized method to select2 in clients app!
  def contains
    @municipalities = []

    Region.all.sort_by! { |r| r.name }.each do |region|
      municipalities_group = []
      region.municipalities.each do |municipality|
        if municipality.name.downcase.match(/#{params[:name].downcase}/)
          municipality_hash = Hash.new
          municipality_hash["id"] = municipality.id
          municipality_hash["text"] = municipality.name + " (" + municipality.province.abbreviation + ")"
          municipalities_group = municipalities_group << municipality_hash 
        end
      end

      if !municipalities_group.empty?
        region_group = Hash.new
        region_group["text"] = region.name
        region_group["children"] = municipalities_group
        @municipalities = @municipalities << region_group
      end
    end

    respond_to do |format|
      format.json { render json: @municipalities }
    end
  end

  # GET /municipalities
  # GET /municipalities.json
  def all
    @municipalities = Municipality.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @municipalities }
    end
  end

  def index
    @municipalities = Municipality.where(:province_id => params[:province_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @municipalities }
    end
  end

  def map
    @municipalities = Municipality.where("latitude IS NOT NULL")

    @markers = Gmaps4rails.build_markers(@municipalities) do |municipality, marker|
      marker.lat municipality.latitude
      marker.lng municipality.longitude
      marker.title municipality.id.to_s
      marker.infowindow "Loading ..."
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /municipalities/1
  # GET /municipalities/1.json
  def show
    @municipality = Municipality.find(params[:id])

    @fractions, @alphaParams = 
       @municipality.fractions.sort_by{ |m| m.name.downcase }
         .alpha_paginate(params[:letter], {:js => true}){|fraction| fraction.name}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @municipality }
    end
  end

  def infobox
    @municipality = Municipality.find(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false} # infobox.html.erb
      format.json { render json: @municipality }
    end
  end

  # GET /municipalities/new
  # GET /municipalities/new.json
  def new
    @municipality = Municipality.new
    @province = nil
    if params[:province_id]
      @province = Province.find(params[:province_id].to_i)
    else
      @province = Province.first
    end
    @object = [@province, @municipality]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @municipality }
    end
  end

  # GET /municipalities/1/edit
  def edit
    @municipality = Municipality.find(params[:id])
    @province = @municipality.province
    @object = @municipality
  end

  # POST /municipalities
  # POST /municipalities.json
  def create
    @municipality = Municipality.new(params[:municipality])

    respond_to do |format|
      if @municipality.save
        format.html { redirect_to @municipality, notice: 'Municipality was successfully created.' }
        format.json { render json: @municipality, status: :created, location: @municipality }
      else
        format.html { render action: "new" }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /municipalities/1
  # PUT /municipalities/1.json
  def update
    @municipality = Municipality.find(params[:id])

    respond_to do |format|
      if @municipality.update_attributes(params[:municipality])
        format.html { redirect_to @municipality, notice: 'Municipality was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @municipality.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /municipalities/1
  # DELETE /municipalities/1.json
  def destroy
    @municipality = Municipality.find(params[:id])
    @municipality.destroy

    respond_to do |format|
      format.html { redirect_to trips_url }
      format.json { head :no_content }
    end
  end
end
