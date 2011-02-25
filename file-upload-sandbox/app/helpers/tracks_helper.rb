module TracksHelper
  
  def showTrackPathLinked(track)
    link_to @track.public_filename, @track.public_filename
  end
end
