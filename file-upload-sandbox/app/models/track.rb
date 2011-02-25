class Track < ActiveRecord::Base
  
  has_attachment :content_type => ['audio/x-aiff', 'audio/wav', 'audio/flac', 'audio/ogg', 'audio/mpeg', 'audio/aac'],
                 :storage => :file_system,
                 :path_prefix => 'public/tracks',
                 :max_size => 100.megabyte
  
  validates_as_attachment
end
