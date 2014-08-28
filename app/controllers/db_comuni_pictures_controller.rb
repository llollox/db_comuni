class DbComuniPicturesController < ApplicationController

  # GET /pictures
  # GET /pictures.json
  def index
    match = request.url.scan(/provinces|regions|municipalities/)[0]
    _class = match.singularize.capitalize.constantize
    id = params[(match.singularize + "_id").to_sym].to_i

    @picture = _class.find(id).symbol
    @picture["photo_url"] = @picture.photo.url if !@picture.nil?

    respond_to do |format|
      format.json { render json: @picture }
    end
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @picture }
    end
  end

  # GET /pictures/new
  # GET /pictures/new.json
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @picture }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @picture }
    end
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(params[:picture])
    
    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, flash: {success: "Picture was successfully created!"}}
        format.json { render json: @picture, status: :created, location: @picture }
      else
        format.html { render action: "new" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  # PUT /pictures/1.json
  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to @picture, flash: {success: "Picture was successfully updated!"}}
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to pictures_url flash: {success: "Picture was successfully deleted!"}}
      format.json { head :no_content }
    end
  end
end
