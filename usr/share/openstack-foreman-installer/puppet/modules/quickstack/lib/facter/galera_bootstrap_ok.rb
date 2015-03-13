Facter.add("galera_bootstrap_ok") do
  setcode do
    not (File.exist?( "/var/lib/mysql/cinder") ||
         File.exist?( "/var/lib/mysql/keystone") ||
         File.exist?( "/var/lib/mysql/glance") ||
         File.exist?( "/var/lib/mysql/neutron") ||
         File.exist?( "/var/lib/mysql/nova") ||
         File.exist?( "/var/lib/mysql/heat"))
  end
end
