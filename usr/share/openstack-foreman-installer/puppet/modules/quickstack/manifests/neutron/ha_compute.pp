# Quickstack compute node configuration for neutron (OpenStack Networking)
class quickstack::neutron::ha_compute (
  $admin_password               = $quickstack::params::admin_password,
  $agent_type                   = 'ovs',
  $auth_host                    = '127.0.0.1',
  $ceilometer                   = 'true',
  $ceilometer_metering_secret   = $quickstack::params::ceilometer_metering_secret,
  $ceilometer_user_password     = $quickstack::params::ceilometer_user_password,
  $ceph_cluster_network         = '',
  $ceph_public_network          = '',
  $ceph_fsid                    = '',
  $ceph_images_key              = '',
  $ceph_volumes_key             = '',
  $ceph_mon_host                = [ ],
  $ceph_mon_initial_members     = [ ],
  $ceph_osd_pool_default_size   = '',
  $ceph_osd_journal_size        = '',
  $cinder_backend_gluster       = $quickstack::params::cinder_backend_gluster,
  $cinder_backend_nfs           = 'false',
  $cinder_backend_rbd           = 'true',
  $glance_backend_rbd           = 'true',
  $glance_host                  = '127.0.0.1',
  $nova_host                    = '127.0.0.1',
  $enable_tunneling             = $quickstack::params::enable_tunneling,
  $mysql_host                   = $quickstack::params::mysql_host,
  $neutron_db_password          = $quickstack::params::neutron_db_password,
  $neutron_user_password        = $quickstack::params::neutron_user_password,
  $neutron_host                 = '127.0.0.1',
  $nova_db_password             = $quickstack::params::nova_db_password,
  $nova_user_password           = $quickstack::params::nova_user_password,
  $ovs_bridge_mappings          = $quickstack::params::ovs_bridge_mappings,
  $ovs_bridge_uplinks           = $quickstack::params::ovs_bridge_uplinks,
  $ovs_vlan_ranges              = $quickstack::params::ovs_vlan_ranges,
  $ovs_tunnel_iface             = 'eth1',
  $ovs_tunnel_network           = '',
  $ovs_l2_population            = 'True',
  $amqp_provider                = $quickstack::params::amqp_provider,
  $amqp_host                    = $quickstack::params::amqp_host,
  $amqp_port                    = '5672',
  $amqp_ssl_port                = '5671',
  $amqp_username                = $quickstack::params::amqp_username,
  $amqp_password                = $quickstack::params::amqp_password,
  $tenant_network_type          = $quickstack::params::tenant_network_type,
  $tunnel_id_ranges             = '1:1000',
  $ovs_vxlan_udp_port           = $quickstack::params::ovs_vxlan_udp_port,
  $ovs_tunnel_types             = $quickstack::params::ovs_tunnel_types,
  $verbose                      = $quickstack::params::verbose,
  $ssl                          = $quickstack::params::ssl,
  $security_group_api		= 'neutron',
  $mysql_ca                     = $quickstack::params::mysql_ca,
  $libvirt_images_rbd_pool      = 'volumes',
  $libvirt_images_rbd_ceph_conf = '/etc/ceph/ceph.conf',
  $libvirt_inject_password      = 'false',
  $libvirt_inject_key           = 'false',
  $libvirt_images_type          = 'rbd',
  $rbd_user                     = 'admin',
  $rbd_secret_uuid              = '',
  $private_iface                = '',
  $private_ip                   = '',
  $private_network              = '',

  $br_ex_ip			= '',

  $ceph_pub_ip,

) inherits quickstack::params {

  $ceph_mon_hosts = ['172.16.10.2', '172.16.10.3', '172.16.10.4']
  $ntp_server1  = '10.168.0.2'
  $ntp_server2  = '192.168.52.2'

  file { '/etc/sysconfig/network-scripts/ifup-ovs':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifup-ovs.erb'),
  }

  $admin_ip = $::ipaddress

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

  #if $br_ex_ip != undef {
  #}
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

  file { '/etc/sysconfig/network-scripts/ifcfg-enp32s0f1.3000':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-enp32s0f1.3000.erb'),
    before  => Package ['ceph'],
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
                  '/etc/sysconfig/network-scripts/ifcfg-enp32s0f1.3000',
                 ]

  service { 'network':
      ensure     => running,
      enable     => true,
      subscribe  => File[$ifcfg_files],
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

  if str2bool_i("$ssl") {
    $qpid_protocol = 'ssl'
    $real_amqp_port = $amqp_ssl_port
    $sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_host}/neutron?ssl_ca=${mysql_ca}"
  } else {
    $qpid_protocol = 'tcp'
    $real_amqp_port = $amqp_port
    $sql_connection = "mysql://neutron:${neutron_db_password}@${mysql_host}/neutron"
  }

  class { '::neutron':
    allow_overlapping_ips => true,
    rpc_backend           => amqp_backend('neutron', $amqp_provider),
    #qpid_hostname         => $amqp_host,
    qpid_hostname         => $mysql_host,
    qpid_port             => $real_amqp_port,
    qpid_protocol         => $qpid_protocol,
    qpid_username         => $amqp_username,
    qpid_password         => $amqp_password,
    #rabbit_host           => $amqp_host,
    rabbit_host           => $mysql_host,
    rabbit_port           => $real_amqp_port,
    rabbit_user           => $amqp_username,
    rabbit_password       => $amqp_password,
    verbose               => $verbose,
  }
  ->
  class { '::neutron::server::notifications':
    notify_nova_on_port_status_changes => true,
    notify_nova_on_port_data_changes   => true,
    nova_url                           => "http://${nova_host}:8774/v2",
    nova_admin_auth_url                => "http://${auth_host}:35357/v2.0",
    nova_admin_username                => "nova",
    nova_admin_password                => "${nova_user_password}",
  }

  neutron_config {
    'database/connection':                  value => $sql_connection;
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

    $local_ip = find_ip("$ovs_tunnel_network","$ovs_tunnel_iface","")
    class { '::neutron::agents::ovs':
      bridge_uplinks      => $ovs_bridge_uplinks,
      bridge_mappings     => $ovs_bridge_mappings,
      local_ip            => $local_ip,
      enable_tunneling    => str2bool_i("$enable_tunneling"),
      tunnel_types     => $ovs_tunnel_types,
      vxlan_udp_port   => $ovs_vxlan_udp_port,
    }
  }

  class { '::nova::network::neutron':
    neutron_admin_password => $neutron_user_password,
    neutron_url            => "http://${neutron_host}:9696",
    neutron_admin_auth_url => "http://${auth_host}:35357/v2.0",
    security_group_api     => $security_group_api,
    vif_plugging_is_fatal  => false,
    vif_plugging_timeout   => 10,
  }


  class { 'quickstack::compute_common':
    admin_password               => $admin_password,
    auth_host                    => $auth_host,
    ceilometer                   => $ceilometer,
    ceilometer_metering_secret   => $ceilometer_metering_secret,
    ceilometer_user_password     => $ceilometer_user_password,
    ceph_cluster_network         => $ceph_cluster_network,
    ceph_public_network          => $ceph_public_network,
    ceph_fsid                    => $ceph_fsid,
    ceph_images_key              => $ceph_images_key,
    ceph_volumes_key             => $ceph_volumes_key,
    ceph_mon_host                => $ceph_mon_host,
    ceph_mon_initial_members     => $ceph_mon_initial_members,
    ceph_osd_pool_default_size   => $ceph_osd_pool_default_size,
    ceph_osd_journal_size        => $ceph_osd_journal_size,
    cinder_backend_gluster       => $cinder_backend_gluster,
    cinder_backend_nfs           => $cinder_backend_nfs,
    cinder_backend_rbd           => $cinder_backend_rbd,
    glance_backend_rbd           => $glance_backend_rbd,
    glance_host                  => $glance_host,
    mysql_host                   => $mysql_host,
    nova_db_password             => $nova_db_password,
    nova_host                    => $nova_host,
    nova_user_password           => $nova_user_password,
    amqp_provider                => $amqp_provider,
    #amqp_host                    => $amqp_host,
    amqp_host                    => $mysql_host,
    amqp_port                    => $amqp_port,
    amqp_ssl_port                => $amqp_ssl_port,
    amqp_username                => $amqp_username,
    amqp_password                => $amqp_password,
    verbose                      => $verbose,
    ssl                          => $ssl,
    mysql_ca                     => $mysql_ca,
    libvirt_images_rbd_pool      => $libvirt_images_rbd_pool,
    libvirt_images_rbd_ceph_conf => $libvirt_images_rbd_ceph_conf,
    libvirt_inject_password      => $libvirt_inject_password,
    libvirt_inject_key           => $libvirt_inject_key,
    libvirt_images_type          => $libvirt_images_type,
    rbd_user                     => $rbd_user,
    rbd_secret_uuid              => $rbd_secret_uuid,
    private_iface                => $private_iface,
    private_ip                   => $private_ip,
    private_network              => $private_network,
  }

  class {'quickstack::neutron::firewall::gre':}

  class {'quickstack::neutron::firewall::vxlan':
    port => $ovs_vxlan_udp_port,
  }

  package { 'ceph':
    ensure   => 'installed',
    name     => 'ceph',
    provider => 'yum',
    before  => File['/etc/ceph/ceph.conf'],
  }

  file { '/etc/ceph/ceph.conf':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ceph.config.erb'),
    before  => File['/etc/ceph/ceph.client.admin.keyring'],
  }

  file { '/etc/ceph/ceph.mon.keyring':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ceph.mon.keyring.erb'),
    before  => File['/etc/ceph/ceph.client.admin.keyring'],
  }

  file { '/etc/ceph/ceph.client.admin.keyring':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ceph.client.admin.keyring.erb'),
  }

}
