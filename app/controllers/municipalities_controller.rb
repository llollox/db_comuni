class MunicipalitiesController < ApplicationController
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  before_filter :check_login, :only => [:delete, :create, :new, :update, :edit]

  # GET /municipalities
  # GET /municipalities.json
  def all
    @municipalities, @alphaParams = 
       Municipality.all.sort_by{ |p| p.province_id }
         .alpha_paginate(params[:letter], {:js => true}){|municipality| municipality.name}

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

  def search
    @municipality = findItemByName("Municipality", params[:word])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @municipality }
    end
  end

  # GET /municipalities/1
  # GET /municipalities/1.json
  def show
    @municipality = Municipality.find(params[:id])

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
