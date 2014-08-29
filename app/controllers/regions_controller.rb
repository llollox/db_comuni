class RegionsController < ApplicationController
  # require "#{Rails.root}/lib/tasks/task_utilities"
  # include TaskUtilities
  
  # skip_before_filter  :verify_authenticity_token

  before_filter :check_login, :only => [:delete, :create, :new, :update, :edit]
  
  # GET /regions
  # GET /regions.json
  def index
    @regions, @alphaParams = 
      Region.all.sort_by{ |r| r.name.downcase }
        .alpha_paginate(params[:letter], {:js => true}){|region| region.name}

    respond_to do |format|
      format.html
      format.json { render json: @regions }
    end
  end

  def search
    name = encode(params[:name]) if params[:name]
    
    if !name.nil?

      if encode(name) == "trentino" || encode(name) == "altoadige"
        @region = findItemByName("Region", "trentinoaltoadige")
      elsif encode(name) == "romagna" || encode(name) == "emilia"
        @region = findItemByName("Region", "emiliaromagna")
      elsif encode(name) == "friuli"
        @region = findItemByName("Region", "friuliveneziagiulia")
      elsif encode(name) == "aosta" || encode(name) == "valdaosta"
        @region = findItemByName("Region", "valledaosta")
      else
        @region = findItemByName("Region", name)
      end

    end

    respond_to do |format|
      format.json { render json: @region }
    end
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
    @region = Region.find(params[:id])

    @provinces, @alphaParams = 
      @region.provinces.sort_by{ |p| p.name.downcase }
        .alpha_paginate(params[:letter], {:js => true}){|province| province.name}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @region }
    end
  end

  # GET /regions/new
  # GET /regions/new.json
  def new
    @region = Region.new
    @object = [Division.first, @region]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @region }
    end
  end

  # GET /regions/1/edit
  def edit
    @region = Region.find(params[:id])
    @object = @region
  end

  # POST /regions
  # POST /regions.json
  def create
    @region = Region.new(params[:region])
    

    respond_to do |format|
      if @region.save
        format.html { redirect_to @region, flash: {success: "Region was successfully created!"}}
        format.json { render json: @region, status: :created, location: @region }
      else
        format.html { render action: "new" }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /regions/1
  # PUT /regions/1.json
  def update
    @region = Region.find(params[:id])

    respond_to do |format|
      if @region.update_attributes(params[:region])
        format.html { redirect_to @region, flash: {success: "Region was successfully updated!"}}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    @region = Region.find(params[:id])
    @region.destroy

    respond_to do |format|
      format.html { redirect_to regions_url flash: {success: "Region was successfully deleted!"}}
      format.json { head :no_content }
    end
  end
end
