# Quickstack compute node configuration for neutron (OpenStack Networking)
class quickstack::neutron::ceph_node (
      $ceph_pub_ip,
      $ceph_cluster_ip,
) {
   class { 'quickstack::neutron::ceph2node2cfg' : 
        ceph_pub_ip => $ceph_pub_ip,
        ceph_cluster_ip =>$ceph_cluster_ip,
   }

#  file { '/etc/sysconfig/network-scripts/ifup-ovs':
#    ensure  => present,
#    mode    => '0755',
#    owner   => 'root',
#    group   => 'root',
#    content => template('quickstack/ifup-ovs.erb'),
#  }

#  if $ceph_pub_ip != undef { 
#    file { '/etc/sysconfig/network-scripts/ifcfg-enp15s0f1.3000':
#    ensure  => present,
#    mode    => '0644',
#    owner   => 'root',
#    group   => 'root',
#    content => template('quickstack/ifcfg-enp15s0f1.3000.erb'),
#    before  => Package ['ceph'],
#    }
#  }
#  if $ceph_cluster_ip != undef { 
#    file { '/etc/sysconfig/network-scripts/ifcfg-enp15s0f0.3002':
#    ensure  => present,
#    mode    => '0644',
#    owner   => 'root',
#    group   => 'root',
#    content => template('quickstack/ifcfg-enp15s0f0.3002.erb'),
#    before  => Package ['ceph'],
#    }
#  }

#  if $ceph_admin_ip != undef { 
#    file { '/etc/sysconfig/network-scripts/ifcfg-eno1':
#    ensure  => present,
#    mode    => '0644',
#    owner   => 'root',
#    group   => 'root',
#    content => template('quickstack/ifcfg-admin-ceph.erb'),
#    before  => Package ['ceph'],
#    }
#  }

#  $ifcfg_files = ['/etc/sysconfig/network-scripts/ifcfg-enp15s0f0.3002',
#                  '/etc/sysconfig/network-scripts/ifcfg-enp15s0f1.3000',
#                  '/etc/sysconfig/network-scripts/ifcfg-eno1',
#                 ]

#  service { 'network':
#      ensure     => running,
#      enable     => true,
#      subscribe  => File[$ifcfg_files],
#  }

#  package { 'ntp':
#    ensure   => 'installed',
#    name     => 'ntp',
#    provider => 'yum',
#    before  => File['/etc/ntp.conf'],
#  }

#  file { '/etc/ntp.conf':
#    ensure => present,
#    mode   => '0644',
#    owner  => 'root',
#    group  => 'root',
#    content => template('quickstack/ntp-client.conf.erb'),
#  }

#  file { '/etc/ntp/step-tickers':
#    ensure => present,
#    mode   => '0644',
#    owner  => 'root',
#    group  => 'root',
#    content => template('quickstack/step-tickers.erb'),
#  }

#  service { 'ntpd':
#    ensure => 'running',
#    name   => 'ntpd',
#    enable => true,
#    subscribe  => File['/etc/ntp.conf','/etc/ntp/step-tickers'],
#  }


  $ceph_node_name = "$::hostname"

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

#  service { 'firewalld':
#        ensure => 'stopped',
#        name   => 'firewalld',
#        enable => false,
#  }

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

