class CapsController < ApplicationController

  require "#{Rails.root}/lib/tasks/task_utilities"
  include TaskUtilities

  before_filter :check_login, :only => [:delete, :create, :new, :update, :edit]


  def search
    @caps = Cap.where(:number => encode(params[:number])) if params[:number]

    respond_to do |format|
      format.json { render json: @caps }
    end

  end

  def index
    @caps = Cap.where(:municipality_id => params[:municipality_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @caps }
    end
  end

  # GET /municipalities/1
  # GET /municipalities/1.json
  def show
    @cap = Cap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cap }
    end
  end

  # GET /municipalities/new
  # GET /municipalities/new.json
  def new
    @cap = Cap.new
    @municipality = nil
    if params[:municipality_id]
      @municipality = Municipality.find(params[:municipality_id].to_i)
    else
      @municipality = Municipality.first
    end
    @object = [@municipality, @cap]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cap }
    end
  end

  # GET /municipalities/1/edit
  def edit
    @cap = Cap.find(params[:id])
    @municipality = @cap.municipality
    @object = @cap
  end

  # POST /municipalities
  # POST /municipalities.json
  def create
    @cap = Cap.new(params[:cap])

    @municipality = @cap.municipality

    respond_to do |format|
      if @cap.save
        format.html { redirect_to @municipality, notice: 'Cap was successfully created.' }
        format.json { render json: @cap, status: :created, location: @cap }
      else
        format.html { render action: "new" }
        format.json { render json: @cap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /municipalities/1
  # PUT /municipalities/1.json
  def update
    @cap = Cap.find(params[:id])

    respond_to do |format|
      if @cap.update_attributes(params[:cap])
        format.html { redirect_to @cap.municipality, notice: 'Cap was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cap.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /municipalities/1
  # DELETE /municipalities/1.json
  def destroy
    @cap = Cap.find(params[:id])
    @municipality = @cap.municipality
    @cap.destroy

    respond_to do |format|
      format.html { redirect_to @municipality }
      format.json { head :no_content }
    end
  end

end
