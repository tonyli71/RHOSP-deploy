# Quickstack compute node configuration for neutron (OpenStack Networking)
class quickstack::neutron::ceph2node2cfg (

  $ceph_public_network           = $quickstack::params::ceph_public_network,
  $ceph_cluster_network          = $quickstack::params::ceph_cluster_network,
  $ceph_mon_hosts                = $quickstack::params::ceph_mon_hosts,
  $ceph_mon_initial_members      = $quickstack::params::ceph_mon_initial_members,
  $ceph_fsid                     = $quickstack::params::ceph_fsid,
  $ceph_client_admin_key         = $quickstack::params::ceph_client_admin_key,
  $ceph_mon_id                   = $quickstack::params::ceph_mon_id,
  $ceph_mon_key                  = $quickstack::params::ceph_mon_key,
#  #$ceph_node_name                = undef,
  $ceph_osd_devs 		 = [],

  $ntp_server1  = $quickstack::tparams::ntp_server1,
  $ntp_server2  = $quickstack::tparams::ntp_server2,
  $osd_pool_default_size = $quickstack::tparams::osd_pool_default_size,

  $ceph_pub_ip,
  $ceph_cluster_ip,

) inherits quickstack::params {

  $ceph_admin_ip = $::ipaddress

  file { '/etc/sysconfig/network-scripts/ifup-ovs':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifup-ovs.erb'),
  }

  if $ceph_pub_ip != undef { 
    file { '/etc/sysconfig/network-scripts/ifcfg-enp15s0f1.3000':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-enp15s0f1.3000.erb'),
    before  => Package ['ceph'],
    }
  }
  if $ceph_cluster_ip != undef { 
    file { '/etc/sysconfig/network-scripts/ifcfg-enp15s0f0.3002':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-enp15s0f0.3002.erb'),
    before  => Package ['ceph'],
    }
  }

  if $ceph_admin_ip != undef { 
    file { '/etc/sysconfig/network-scripts/ifcfg-eno1':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ifcfg-admin-ceph.erb'),
    before  => Package ['ceph'],
    }
  }

  $ifcfg_files = ['/etc/sysconfig/network-scripts/ifcfg-enp15s0f0.3002',
                  '/etc/sysconfig/network-scripts/ifcfg-enp15s0f1.3000',
                  '/etc/sysconfig/network-scripts/ifcfg-eno1',
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


#  $ceph_node_name = "$::hostname"

#  class ceph::yum::ceph (
#      $release = 'cuttlefish'
#   ) {
#       yumrepo { 'ceph':
#       descr => "Ceph ${release} repository",
#       baseurl => "http://ceph.com/rpm-${release}/el6/x86_64/",
#       gpgkey =>
#          'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc',
#          gpgcheck => 1,
#          enabled => 1,
#          priority => 5,
#       before => Package['ceph'],
#       }
#  }

#  class { 'ceph::conf': 
#     fsid => $ceph_fsid,
#     cluster_network  => $ceph_public_network,
#     public_network => $ceph_public_network,
#     osd_pool_default_size => 2,
#     osd_pool_default_min_size  => 2,
#     mon_host => '172.16.250.80',
#     mon_initial_members => 'ceph1',
#     authentication_type => 'none',
#  }

#  $ensure                     = present,
#  $keyring                    = undef,
#  $osd_pool_default_pg_num    = undef,
#  $osd_pool_default_pgp_num   = undef,
#  $osd_pool_default_crush_rule= undef,
#  $mon_osd_full_ratio         = undef,
#  $mon_osd_nearfull_ratio     = undef,
#  $require_signatures         = undef,
#  $cluster_require_signatures = undef,
#  $service_require_signatures = undef,
#  $sign_messages              = undef,

  service { 'firewalld':
        ensure => 'stopped',
        name   => 'firewalld',
        enable => false,
  }

  $ceph_node_name = "$::hostname"

  exec { "setenforce_0":
    command         => "setenforce 0",
    path            => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    user            => root,
    onlyif => "getenforce | grep Enforcing",
    before  => Exec[ "create_mon_${ceph_node_name}"],
  }

  file { '/etc/selinux/config':
    ensure  => present,
    content => template('quickstack/disable_seliux.erb'),
    notify  => Exec['setenforce_0'],
    before  => Package['ceph'],
  }

#  service { 'iptables':
#        ensure => 'stopped',
#        name   => 'iptables',
#        enable => false,
#  }

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
    before  => Service ['ceph'],
  }

  file { '/usr/bin/ceph_create_osd':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/ceph_create_osd.erb'),
  }

  exec { "create_mon_${ceph_node_name}":
    command         => "mkdir -p /var/lib/ceph/mon/ceph-${ceph_node_name};
			mkdir -p /var/lib/ceph/bootstrap-osd/;
			ceph-authtool -C /var/lib/ceph/bootstrap-osd/ceph.keyring;
			ceph-mon --mkfs -i ${ceph_node_name} --keyring /etc/ceph/ceph.mon.keyring;
                        touch /var/lib/ceph/mon/ceph-${ceph_node_name}/done;
			touch /var/lib/ceph/mon/ceph-${ceph_node_name}/sysvinit;
                        /sbin/service ceph -c /etc/ceph/ceph.conf start mon.${ceph_node_name};
                        ",
    path            => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    user            => root,
#    notify          => Notify["create_mon_${ceph_node_name}"],
    onlyif => "test ! -f /var/lib/ceph/mon/ceph-${ceph_node_name}/done"
  }

   $ceph_osd_dev  = "/dev/rhel_${::hostname}/osd"
#ceph_osd_id=ceph osd create;
   exec { "create_osd_${ceph_osd_dev}":
    command         => "/usr/bin/ceph_create_osd ${ceph_osd_dev}",
    path            => ['/usr/bin','/usr/sbin','/bin','/sbin'],
    user            => root,
    onlyif => "test ! -f /var/lib/ceph/osd/ceph-osd/osd"
   }

  service { 'ceph':
        ensure => 'running',
        name   => 'ceph',
        enable => true,
      }


#    /ceph-default/ {
#       ceph::conf{
#         mon_host => 'mon1.a.tld,mon2.a.tld.com,mon3.a.tld'
#       };
#    }

#   $mon_secret = 'AQD7kyJQQGoOBhAAqrPAqSopSwPrrfMMomzVdw=='

#   $id = 0 # must be unique for each MON in the cluster

#   ceph::mon { $id:
#     monitor_secret => $mon_secret,
#     mon_addr       => '192.168.0.10', # The host's «public» IP address
#   }

#   ceph::osd { '/dev/vdb': }

}

