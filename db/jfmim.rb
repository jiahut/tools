require 'active_record'
require 'Active_support'
require 'mysql2' # or 'pg' or 'sqlite3'

# Change the following to reflect your database settings
ActiveRecord::Base.establish_connection(
  adapter:  'mysql2', # or 'postgresql' or 'sqlite3'
  host:     '192.180.2.65',
  port:     '3312',
  database: 'jf_recurrence',
  username: 'root',
  password: 'mysql'
)

# Define your classes based on the database, as always
# class SomeClass < ActiveRecord::Base
#   #blah, blah, blah
# end
#
ActiveRecord::Base.connection.tables.each do | table_name |
  # puts table_name
  # puts table_name.camelize
  eval <<-EOF
  class #{table_name.camelize} < ActiveRecord::Base
    self.table_name = "#{table_name}"
  end
  EOF
end

# class User < ActiveRecord::Base
#   self.table_name = "user"
# end
# Now do stuff with it
# puts SomeClass.find :all
