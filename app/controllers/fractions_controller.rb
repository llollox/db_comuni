  class FractionsController < ApplicationController
  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  before_filter :check_login, :only => [:delete, :create, :new, :update, :edit]


  def search
    name = encode(params[:name]) if params[:name]
    region_id = encode(params[:region_id]) if params[:region_id]

    if !region_id.nil?
      region = Region.find(region_id.to_i)
      @fractions = []
      region.fractions.each do |fraction|
        if encode(fraction.name) == encode(name) && region_id.to_i == fraction.region_id
          @fractions = @fractions << fraction 
          break
        end
      end
    else
      @fractions = findItemByName("Fraction", name)
    end

    if !@fractions.blank? && @fractions.is_a?(Array)
      @fractions = @fractions.first if @fractions.size == 1 
    end

    respond_to do |format|
      format.json { render json: @fractions }
    end

  end

  # GET /fractions
  # GET /fractions.json
  def all
    @fractions, @alphaParams = 
       Fraction.all.sort_by{ |f| f.name }
         .alpha_paginate(params[:letter], {:js => true}){|fraction| fraction.name}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fractions }
    end
  end

  def index
    @fractions = Fraction.where(:municipality_id => params[:municipality_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fractions }
    end
  end

  # GET /municipalities/1
  # GET /municipalities/1.json
  def show
    @fraction = Fraction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fraction }
    end
  end

  # GET /municipalities/new
  # GET /municipalities/new.json
  def new
    @fraction = Fraction.new
    @municipality = nil
    if params[:municipality_id]
      @municipality = Municipality.find(params[:municipality_id].to_i)
    else
      @municipality = Municipality.first
    end
    @object = [@municipality, @fraction]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fraction }
    end
  end

  # GET /municipalities/1/edit
  def edit
    @fraction = Fraction.find(params[:id])
    @municipality = @fraction.municipality
    @object = @fraction
  end

  # POST /municipalities
  # POST /municipalities.json
  def create
    @fraction = Fraction.new(params[:fraction])

    @municipality = @fraction.municipality

    respond_to do |format|
      if @fraction.save
        format.html { redirect_to @municipality, notice: 'Fraction was successfully created.' }
        format.json { render json: @fraction, status: :created, location: @fraction }
      else
        format.html { render action: "new" }
        format.json { render json: @fraction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /municipalities/1
  # PUT /municipalities/1.json
  def update
    @fraction = Fraction.find(params[:id])

    respond_to do |format|
      if @fraction.update_attributes(params[:fraction])
        format.html { redirect_to @fraction.municipality, notice: 'Fraction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fraction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /municipalities/1
  # DELETE /municipalities/1.json
  def destroy
    @fraction = Fraction.find(params[:id])
    @fraction.destroy

    respond_to do |format|
      format.html { redirect_to regions_url }
      format.json { head :no_content }
    end
  end
end
