# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_file-upload-sandbox_session',
  :secret      => 'd5f0328080553516050559a5c8730d7622298fe91d5daddde684a08ca2c7f8cc50108f7cde655ffc421cabc7648dd29c11f30fc59fa8770c5b3529f66d125894'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
