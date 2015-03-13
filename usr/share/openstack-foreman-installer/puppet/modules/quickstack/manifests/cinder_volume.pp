class quickstack::cinder_volume(
  $backend_eqlx           = false,
  $backend_eqlx_name      = ['eqlx'],
  $backend_glusterfs      = false,
  $backend_glusterfs_name = 'glusterfs',
  $backend_iscsi          = false,
  $backend_iscsi_name     = 'iscsi',
  $backend_nfs            = false,
  $backend_nfs_name       = 'nfs',
  $backend_rbd            = false,
  $backend_rbd_name       = 'rbd',
  # when adding a new backend, add a type to cinder_volume_types class

  $multiple_backends      = false,

  $iscsi_bind_addr        = '',

  $glusterfs_shares       = [],

  $nfs_shares             = [],
  $nfs_mount_options      = undef,

  $san_ip                 = [''],
  $san_login              = ['grpadmin'],
  $san_password           = [''],
  $san_thin_provision     = [false],
  $eqlx_group_name        = ['group-0'],
  $eqlx_pool              = ['default'],
  $eqlx_use_chap          = [false],
  $eqlx_chap_login        = ['chapadmin'],
  $eqlx_chap_password     = [''],

  $rbd_pool               = 'volumes',
  $rbd_ceph_conf          = '/etc/ceph/ceph.conf',
  $rbd_flatten_volume_from_snapshot
                          = false,
  $rbd_max_clone_depth    = '5',
  $rbd_user               = 'volumes',
  $rbd_secret_uuid        = '',

  $enabled                = true,
  $manage_service         = true,
) {
  class { '::cinder::volume':
    enabled        => str2bool_i("$enabled"),
    manage_service => str2bool_i("$manage_service"),
  }

  if str2bool_i("$backend_rbd") {
    class {'cinder::glance': }
  }

  if !str2bool_i("$multiple_backends") {
    # single backend

    # ensure multiple backends config option is empty
    class { 'cinder::backends':
      enabled_backends => [],
    }

    if str2bool_i("$backend_glusterfs") {
      if defined('gluster::client') {
        class { 'gluster::client': }
        ->
        Class['::cinder::volume']
      } else {
        class { 'puppet::vardir': }
        ->
        class { 'gluster::mount::base': repo => false }
        ->
        Class['::cinder::volume']
      }

      if ($::selinux != "false") {
        selboolean { 'virt_use_fusefs':
            value => on,
            persistent => true,
        }
      }

      class { '::cinder::volume::glusterfs':
        glusterfs_mount_point_base => '/var/lib/cinder/volumes',
        glusterfs_shares           => $glusterfs_shares,
        glusterfs_shares_config    => '/etc/cinder/shares-glusterfs.conf',
      }
    } elsif str2bool_i("$backend_nfs") {
      include ::quickstack::nfs_common
      Package['nfs-utils'] -> Cinder::Backend::Nfs<| |>

      class { '::cinder::volume::nfs':
        nfs_servers       => $nfs_shares,
        nfs_mount_options => $nfs_mount_options,
        nfs_shares_config => '/etc/cinder/shares-nfs.conf',
      }
    } elsif str2bool_i("$backend_eqlx") {
      class { '::cinder::volume::eqlx':
        san_ip             => $san_ip[0],
        san_login          => $san_login[0],
        san_password       => $san_password[0],
        san_thin_provision => $san_thin_provision[0],
        eqlx_group_name    => $eqlx_group_name[0],
        eqlx_pool          => $eqlx_pool[0],
        eqlx_use_chap      => $eqlx_use_chap[0],
        eqlx_chap_login    => $eqlx_chap_login[0],
        eqlx_chap_password => $eqlx_chap_password[0],
      }
    } elsif str2bool_i("$backend_rbd") {
      Class['quickstack::ceph::client_packages'] -> Cinder::Backend::Rbd<| |>
      class { '::cinder::volume::rbd':
        rbd_pool            => $rbd_pool,
        rbd_ceph_conf       => $rbd_ceph_conf,
        rbd_flatten_volume_from_snapshot
                            => $rbd_flatten_volume_from_snapshot,
        rbd_max_clone_depth => $rbd_max_clone_depth,
        rbd_user            => $rbd_user,
        rbd_secret_uuid     => $rbd_secret_uuid,
      }
    } elsif str2bool_i("$backend_iscsi") {
      include ::quickstack::firewall::iscsi

      class { '::cinder::volume::iscsi':
        iscsi_ip_address => $iscsi_bind_addr,
      }
    } else {
      fail("Enable a backend for cinder-volume.")
    }

  } else {
    # multiple backends

    if str2bool_i("$backend_glusterfs") {
      $glusterfs_backends = ["glusterfs"]

      if defined('gluster::client') {
        class { 'gluster::client': }
        ->
        Class['::cinder::volume']
      } else {
        class { 'puppet::vardir': }
        ->
        class { 'gluster::mount::base': repo => false }
        ->
        Class['::cinder::volume']
      }

      if ($::selinux != "false") {
        selboolean { 'virt_use_fusefs':
            value => on,
            persistent => true,
        }
      }

      cinder::backend::glusterfs { 'glusterfs':
        volume_backend_name        => $backend_glusterfs_name,
        glusterfs_mount_point_base => '/var/lib/cinder/volumes',
        glusterfs_shares           => $glusterfs_shares,
        glusterfs_shares_config    => '/etc/cinder/shares-glusterfs.conf',
      }
    }

    if str2bool_i("$backend_nfs") {
      include ::quickstack::nfs_common
      Package['nfs-utils'] -> Cinder::Backend::Nfs<| |>

      $nfs_backends = ["nfs"]

      cinder::backend::nfs { 'nfs':
        volume_backend_name => $backend_nfs_name,
        nfs_servers         => $nfs_shares,
        nfs_mount_options   => $nfs_mount_options,
        nfs_shares_config   => '/etc/cinder/shares-nfs.conf',
      }
    }

    if str2bool_i("$backend_eqlx") {

      $count = size($backend_eqlx_name)
      $last = $count -1
      $eqlx_backends = produce_array_with_prefix("eqlx",1,$count)  #Initialize with section headers

      # FIXME: with newer parser we should use `each` (with index) instead
      quickstack::eqlx::volume { $last:
        index => $last,
        backend_section_name_array => $eqlx_backends,
        backend_eqlx_name_array => $backend_eqlx_name,
        san_ip_array => $san_ip,
        san_login_array => $san_login,
        san_password_array => $san_password,
        san_thin_provision_array => $san_thin_provision,
        eqlx_group_name_array => $eqlx_group_name,
        eqlx_pool_array => $eqlx_pool,
        eqlx_use_chap_array => $eqlx_use_chap,
        eqlx_chap_login_array => $eqlx_chap_login,
        eqlx_chap_password_array => $eqlx_chap_password,
      }
    }

    if str2bool_i("$backend_rbd") {
      $rbd_backends = ["rbd"]
      Class['quickstack::ceph::client_packages'] -> Cinder::Backend::Rbd<| |>
      
      cinder::backend::rbd { 'rbd':
        volume_backend_name => $backend_rbd_name,
        rbd_pool            => $rbd_pool,
        rbd_ceph_conf       => $rbd_ceph_conf,
        rbd_flatten_volume_from_snapshot
                            => $rbd_flatten_volume_from_snapshot,
        rbd_max_clone_depth => $rbd_max_clone_depth,
        rbd_user            => $rbd_user,
        rbd_secret_uuid     => $rbd_secret_uuid,
      }
    }

    if str2bool_i("$backend_iscsi") {
      $iscsi_backends = ["iscsi"]

      include ::quickstack::firewall::iscsi

      cinder::backend::iscsi { 'iscsi':
        volume_backend_name => $backend_iscsi_name,
        iscsi_ip_address    => $iscsi_bind_addr,
      }
    }

    $enabled_backends = join_arrays_if_exist(
      'glusterfs_backends',
      'nfs_backends',
      'eqlx_backends',
      'rbd_backends',
      'iscsi_backends')
    if $enabled_backends == [] {
      fail("Enable at least one backend for cinder-volume.")
    }

    # $enabled_backends=['DEFAULT']
    # enable the backends
    class { 'cinder::backends':
      enabled_backends => $enabled_backends,
    }
  }
}
