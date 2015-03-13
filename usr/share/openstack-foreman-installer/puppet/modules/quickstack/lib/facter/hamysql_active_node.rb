Facter.add("hamysql_active_node") do

  setcode do
    if File.exist? "/usr/sbin/pcs" and File.exist? "/usr/sbin/crm_node"
      a = Facter::Util::Resolution.exec("/usr/sbin/pcs status 2>/dev/null | grep -P 'mysql-ostk-mysql\\s.*Started' | perl -p -e 's/^.*Started (\\S*).*$/$1/'")
      b = Facter::Util::Resolution.exec("/usr/sbin/crm_node -n 2>/dev/null")
      a==b
    else
     false
    end
  end
end
