# Glance Storage
class quickstack::glance_storage (
  $glance_backend_gluster      = $quickstack::params::glance_backend_gluster,
  $glance_backend_iscsi        = $quickstack::params::glance_backend_iscsi,
  $glance_gluster_volume       = $quickstack::params::glance_gluster_volume,
  $glance_gluster_peers        = $quickstack::params::glance_gluster_peers,
) inherits quickstack::params {

  if $glance_backend_gluster == true {
    if defined('gluster::client') {
      class { 'gluster::client': }
    } else {
      class { 'gluster::mount::base': repo => false }
    }

    if ($::selinux != "false") {
      selboolean{'virt_use_fusefs':
          value => on,
          persistent => true,
      }
    }

    mount { "/var/lib/glance":
      device  => suffix($glance_gluster_peers, ":${glance_gluster_volume}"),
      fstype  => "glusterfs",
      ensure  => "mounted",
      options => "defaults,_netdev",
      atboot  => "true",
    }
  }

  #if $glance_backend_iscsi == true {
  #
  #}
}
