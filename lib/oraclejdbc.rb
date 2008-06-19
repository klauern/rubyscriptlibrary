# Oracle JDBC driver test.  I installed the Oracle JDBC driver off of Oracle's site
# found here: http://www.oracle.com/technology/software/tech/java/sqlj_jdbc/index.html

# This implementation is running on JRuby-1.1.2 with the ActiveRecord-JDBC
# extensions as well as the additional oracle jdbc driver.

require 'rubygems'
gem 'ActiveRecord-JDBC'
gem 'activerecord-jdbc-adapter'
require 'jdbc_adapter'
require 'active_record'

ActiveRecord::Base.establish_connection(
   :adapter => 'jdbc',
   :driver => 'oracle.jdbc.OracleDriver',
   :url => 'jdbc:oracle:thin:@ta02:1521:ta02'
 )

class Employee < ActiveRecord::Base
end