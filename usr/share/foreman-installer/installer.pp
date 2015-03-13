class { 'puppet':
  runmode => 'cron',
  server  => true,
  server_common_modules_path => [
    '/usr/share/openstack-foreman-installer/puppet/modules',
    '/usr/share/openstack-puppet/modules',
  ],
}

class { 'foreman':
  db_type => 'mysql',
  custom_repo => true
}
#
# Check foreman_proxy/manifests/{init,params}.pp for other options
class { 'foreman_proxy':
  custom_repo          => true,
  port                 => '9090',
  registered_proxy_url => "https://${::fqdn}:9090",
  tftp_servername  => '10.168.0.2',
  dhcp             => true,
  dhcp_gateway     => '10.168.0.2',
  dhcp_range       => '10.168.0.50 10.168.0.100',
  dhcp_interface   => 'eth2',

  dns              => true,
  dns_reverse      => '0.168.10.in-addr.arpa',
  dns_forwarders   => ['10.168.0.2'],
  dns_interface    => 'eth2',
}
