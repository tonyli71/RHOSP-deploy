# Quickstack network node configuration for neutron (OpenStack Networking)
class quickstack::neutron::ha_networker (
  $agent_type                    = 'ovs',
  $fixed_network_range           = $quickstack::params::fixed_network_range,
  $neutron_metadata_proxy_secret = $quickstack::params::neutron_metadata_proxy_secret,
  $neutron_db_password           = $quickstack::params::neutron_db_password,
  $neutron_user_password         = $quickstack::params::neutron_user_password,
  $nova_db_password              = $quickstack::params::nova_db_password,
  $nova_user_password            = $quickstack::params::nova_user_password,
  $controller_priv_host          = $quickstack::params::controller_priv_host,
  $ovs_tunnel_iface              = 'eth1',
  $ovs_tunnel_network            = '',
  $ovs_l2_population             = 'True',
  $mysql_host                    = $quickstack::params::mysql_host,
  $amqp_provider                 = $quickstack::params::amqp_provider,
  $amqp_host                     = $quickstack::params::amqp_host,
  $external_network_bridge       = '',
  $amqp_username                 = $quickstack::params::amqp_username,
  $amqp_password                 = $quickstack::params::amqp_password,
  $tenant_network_type           = $quickstack::params::tenant_network_type,
  $ovs_bridge_mappings           = $quickstack::params::ovs_bridge_mappings,
  $ovs_bridge_uplinks            = $quickstack::params::ovs_bridge_uplinks,
  $ovs_vlan_ranges               = $quickstack::params::ovs_vlan_ranges,
  $tunnel_id_ranges              = '1:1000',
  $ovs_vxlan_udp_port            = $quickstack::params::ovs_vxlan_udp_port,
  $ovs_tunnel_types              = $quickstack::params::ovs_tunnel_types,
  $enable_tunneling              = $quickstack::params::enable_tunneling,
  $verbose                       = $quickstack::params::verbose,
  $ssl                           = $quickstack::params::ssl,
  $mysql_ca                      = $quickstack::params::mysql_ca,

  $br_ex_ip,

) inherits quickstack::params {

  file { '/etc/sysconfig/network-scripts/ifup-ovs':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifup-ovs.erb'),
  }

  $admin_ip = $::ipaddress

  $ntp_server1  = '10.168.0.2'
  $ntp_server2  = '192.168.52.2'

  file { '/etc/sysconfig/network-scripts/ifcfg-br-eth0':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-br-eth0.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-br-eth1':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-br-eth1.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-br-eth2':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-br-eth2.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-br-ex':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-br-ex.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-ex-eth1':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-ex-eth1.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-eth1-ex':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-eth1-ex.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-eth1-eth2':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-eth1-eth2.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-eth2-eth1':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-eth2-eth1.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-enp32s0f0':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-enp32s0f0.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  file { '/etc/sysconfig/network-scripts/ifcfg-eno2':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-eno2.erb'),
    require => File['/etc/sysconfig/network-scripts/ifup-ovs']
  }

  $ifcfg_files = ['/etc/sysconfig/network-scripts/ifcfg-br-eth0',
		  '/etc/sysconfig/network-scripts/ifcfg-br-eth1',
		  '/etc/sysconfig/network-scripts/ifcfg-br-eth2',
		  '/etc/sysconfig/network-scripts/ifcfg-br-ex',
		  '/etc/sysconfig/network-scripts/ifcfg-ex-eth1',
		  '/etc/sysconfig/network-scripts/ifcfg-eth1-ex',
		  '/etc/sysconfig/network-scripts/ifcfg-eth2-eth1',
		  '/etc/sysconfig/network-scripts/ifcfg-eth1-eth2',
		  '/etc/sysconfig/network-scripts/ifcfg-enp32s0f0',
		  '/etc/sysconfig/network-scripts/ifcfg-eno2',
                 ]

  service { 'network':
      ensure     => running,
      enable     => true,
      subscribe  => File[$ifcfg_files],
  }

  package { 'keepalived':
    ensure   => 'installed',
    name     => 'keepalived',
    provider => 'yum',
    before  => File['/etc/keepalived/keepalived.conf'],
  }

  file { '/etc/keepalived/keepalived.conf':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/keepalived.conf.networker.erb'),
  }

  service { 'keepalived':
        ensure => 'running',
        name   => 'keepalived',
        enable => true,
        subscribe  => File['/etc/keepalived/keepalived.conf'],
      }

  package { 'ntp':
    ensure   => 'installed',
    name     => 'ntp',
    provider => 'yum',
    before  => File['/etc/ntp.conf'],
  }

  file { '/etc/ntp.conf':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    content => template('quickstack/ntp-client.conf.erb'),
  }

  file { '/etc/ntp/step-tickers':
    ensure => present,
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
    content => template('quickstack/step-tickers.erb'),
  }

  service { 'ntpd':
    ensure => 'running',
    name   => 'ntpd',
    enable => true,
    subscribe  => File['/etc/ntp.conf','/etc/ntp/step-tickers'],
  }

  class {'quickstack::openstack_common': }

  if str2bool_i("$ssl") {
    $qpid_protocol = 'ssl'
    $amqp_port = '5671'
    $sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_host}/neutron?ssl_ca=${mysql_ca}"
  } else {
    $qpid_protocol = 'tcp'
    $amqp_port = '5672'
    $sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_host}/neutron"
  }

  class { '::neutron':
    verbose               => true,
    allow_overlapping_ips => true,
    rpc_backend           => amqp_backend('neutron', $amqp_provider),
    qpid_hostname         => $amqp_host,
    qpid_protocol         => $qpid_protocol,
    qpid_port             => $amqp_port,
    qpid_username         => $amqp_username,
    qpid_password         => $amqp_password,
    rabbit_host           => $amqp_host,
    rabbit_port           => $amqp_port,
    rabbit_user           => $amqp_username,
    rabbit_password       => $amqp_password,
  }

  neutron_config {
    'keystone_authtoken/auth_host':         value => $auth_host;
    'keystone_authtoken/admin_tenant_name': value => 'services';
    'keystone_authtoken/admin_user':        value => 'neutron';
    'keystone_authtoken/admin_password':    value => $neutron_user_password;
  }

  if downcase("$agent_type") == 'ovs' {
    class { '::neutron::plugins::ovs':
      sql_connection      => $sql_connection,
      tenant_network_type => $tenant_network_type,
      network_vlan_ranges => $ovs_vlan_ranges,
      tunnel_id_ranges    => $tunnel_id_ranges,
      vxlan_udp_port      => $ovs_vxlan_udp_port,
    }

    neutron_plugin_ovs { 'AGENT/l2_population': value => "$ovs_l2_population"; }

    $local_ip = find_ip("$ovs_tunnel_network",
                        ["$ovs_tunnel_iface","$external_network_bridge"],
                        "")

    class { '::neutron::agents::ovs':
      bridge_uplinks   => $ovs_bridge_uplinks,
      local_ip         => $local_ip,
      bridge_mappings  => $ovs_bridge_mappings,
      enable_tunneling => str2bool_i("$enable_tunneling"),
      tunnel_types     => $ovs_tunnel_types,
      vxlan_udp_port   => $ovs_vxlan_udp_port,
    }
  }

  class { '::neutron::agents::dhcp': 
      enable_isolated_metadata => true,
      enable_metadata_network => true,
  }

  class { '::neutron::agents::l3':
    #external_network_bridge => $external_network_bridge,
    external_network_bridge => '',
    handle_internal_only_routers => false,
  }

  class { 'neutron::agents::metadata':
    auth_password => $neutron_user_password,
    shared_secret => $neutron_metadata_proxy_secret,
    auth_url      => "http://${controller_priv_host}:35357/v2.0",
    metadata_ip   => $controller_priv_host,
  }

  class { 'neutron::agents::lbaas': }

  class { '::neutron::agents::metering': }

  class { 'neutron::agents::vpnaas': }

  class { 'neutron::services::fwaas': }

  class {'quickstack::neutron::firewall::gre':}

  class {'quickstack::neutron::firewall::vxlan':
    port => $ovs_vxlan_udp_port,
  }

#  package { 'haproxy':
#    ensure   => 'installed',
#    name     => 'haproxy',
#    provider => 'yum',
#    before  => File['/etc/haproxy/haproxy.cfg'],
#  }

  package { 'mariadb':
    ensure   => 'installed',
    name     => 'mariadb',
    provider => 'yum',
  }

  file { '/etc/haproxy/haproxy.cfg':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/haproxy.cfg.erb'),
  }

  service { 'haproxy':
    ensure => 'running',
    name   => 'haproxy',
    enable => true,
    subscribe  => File['/etc/haproxy/haproxy.cfg'],
  }

  firewall { '000 haproxy web admin':
    proto    => 'tcp',
    dport    => ['8282'],
    action   => 'accept',
  }

  firewall { '001 neutron server (API)':
    proto    => 'tcp',
    dport    => ['9696'],
    action   => 'accept',
  }

  firewall { '000 controller incoming':
    proto    => 'tcp',
    dport    => ['4567','4568','4444','3307'],
    action   => 'accept',
  }

  firewall { '001 controller incoming':
    proto    => 'tcp',
    dport    => ['80', '443', '3260', '3306', '5000', '35357', '5672', '8773', '8774', '8775', '8776', '8777', '9292', '6080'],
    action   => 'accept',
  }

  firewall { '001 controller incoming pt2':
    proto    => 'tcp',
    dport    => ['8000', '8003', '8004','6789'],
    action   => 'accept',
  }

  firewall { '001 controller incoming pt3':
    proto    => 'tcp',
    dport    => ['11211','4369','8773','8777'],
    action   => 'accept',
  }

  firewall { '002 ssl controller incoming':
      proto    => 'tcp',
      dport    => ['443', '5671',],
      action   => 'accept',
  }

}
