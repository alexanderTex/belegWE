require 'data_mapper'

DataMapper::setup(:default, ENV.fetch('DATABASE_URL', "sqlite3:///#{Dir.pwd}/data.db"))

class ContactRequest
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :email, String
  property :message, Text
end

DataMapper.finalize
ContactRequest.auto_upgrade!
