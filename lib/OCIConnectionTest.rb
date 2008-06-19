# This project uses a strict Windows Ruby environment to run.  Please see the
# Ruby-OCI8 plugin at http://ruby-oci8.rubyforge.org/en/index.html for
# information on how to set this up on your local machine.  I ran this on 
# Windows XP with Oracle client already installed.  I believe you need a client
# to run this on, but since my computer was already set up with one, I did not
# have to configure anything other than manually installing the gem.
require 'oci8'

class OracleConnector
  def initialize(username, password, serverlocation)
    @user = username
    @pass = password
    @server = serverlocation
  end
  
  def connect_to_server
    @conn = OCI8.new(@user, @pass, @server)
  end
  
  def execute_select(statement)
    @cursor = @conn.exec(statement) do |r|
     puts r.join(',')
    end
    #@cursor.close
  end
  
  def logoff
    @conn.logoff
  end
end

stmt = 'SELECT B.CD_WR, DT_BUDGET_YR, AMT_BUDGET_DOLLARS FROM WP_WRBUD B, WMSERP_WR ERP WHERE B.CD_WR = ERP.CD_WR AND ERP.DT_LAST_ECPD_UPDATE >= SYSDATE - 10'

orcl = OracleConnector.new("eai", "eai", "ta07")
orcl.connect_to_server
orcl.execute_select(stmt)
orcl.logoff
