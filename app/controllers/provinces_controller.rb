class ProvincesController < ApplicationController
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  before_filter :check_login, :only => [:delete, :create, :new, :update, :edit]

  # GET /provinces
  # GET /provinces.json
  def all
    # @provinces = Province.all.sort_by{ |r| r.region_id }
    @provinces, @alphaParams = 
       Province.all.sort_by{ |p| p.name.downcase }
         .alpha_paginate(params[:letter], {:js => true}){|province| province.name}
    @region = Region.first

    respond_to do |format|
      format.html 
      format.json { render json: @provinces }
    end
  end

  def index
    @provinces = Province.where(:region_id => params[:region_id]).
      sort_by{ |p| p.name.downcase }

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @provinces }
    end
  end

   def search
    name = encode(params[:name]) if params[:name]
    
    @province = findItemByName("Province", name) if !name.nil?

    respond_to do |format|
      format.json { render json: @province }
    end
  end

  # GET /provinces/1
  # GET /provinces/1.json
  def show
    @province = Province.find(params[:id])
    
    @municipalities, @alphaParams = 
       @province.municipalities.sort_by{ |m| m.name.downcase }
         .alpha_paginate(params[:letter], {:js => true}){|municipality| municipality.name}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @province }
    end
  end

  # GET /provinces/new
  # GET /provinces/new.json
  def new
    @province = Province.new
    @region = nil
    if params[:region_id]
      @region = Region.find(params[:region_id].to_i)
    else
      @region = Region.first
    end
    @object = [@region, @province]
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @province }
    end
  end

  # GET /provinces/1/edit
  def edit
    @province = Province.find(params[:id])
    @region = @province.region
    @object = @province
  end

  # POST /provinces
  # POST /provinces.json
  def create
    @province = Province.new(params[:province])
    @region = @province.region

    respond_to do |format|
      if @province.save
        format.html { redirect_to @region, flash: {success: "Province was successfully created!"} }
        format.json { render json: @province, status: :created, location: @province }
      else
        format.html { render action: "new" }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /provinces/1
  # PUT /provinces/1.json
  def update
    @province = Province.find(params[:id])

    respond_to do |format|
      if @province.update_attributes(params[:province])
        format.html { redirect_to @province, flash: {success: "Province was successfully updated!"} }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @province.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /provinces/1
  # DELETE /provinces/1.json
  def destroy
    @province = Province.find(params[:id])
    @region = @province.region
    @province.destroy

    respond_to do |format|
      format.html { redirect_to @region, flash: {success: "Province was successfully deleted!"}}
      format.json { head :no_content }
    end
  end
end
