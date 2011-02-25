require 'mime/types'

class TracksController < ApplicationController
  
  protect_from_forgery :only => [:update, :destroy] 
  
  def index
    @tracks = Track.all
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def show
    @track = Track.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
    end
  end
  
  def new
    @track = Track.new
    
    respond_to do |format|
      format.html # new.html.erb
    end
  end
  
  def edit
    @track = Track.find(params[:id])
  end
  
  # called by the uploader only
  def create
    @track = Track.new(params[:track])
    
    # set the content-type based on the filename
    @track.content_type = MIME::Types.type_for(@track.filename).to_s
    
    respond_to do |format|
      format.json do
        if @track.save
          render :json => { :result => 'success', :track_id => @track.id, :track_path => @track.public_filename }
        else
          render :json => { :result => 'error', :error => @track.errors.full_messages.to_sentence }
        end
      end
    end
  end
  
  # called on the save of the title metadata
  def update
    if params[:commit] == "Save"
      @lookupId = params[:track][:id]
      @setOrUpdated = "set"
    else
      @lookupId = params[:id]
      @setOrUpdated = "updated"
    end
    
    @track = Track.find(@lookupId)
    
    if @track.update_attributes(params[:track])
      flash[:notice] = 'Track metadata was successfully ' + @setOrUpdated + '.'
      redirect_to(@track)
    else
      render :action => "new"
    end
  end
  
  def destroy
    @track = Track.find(params[:id])
    @track.destroy
    
    respond_to do |format|
      format.html { redirect_to(tracks_url) }
    end
  end
end