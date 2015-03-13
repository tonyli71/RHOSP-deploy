class quickstack::nfs_common {
  package { 'nfs-utils':
    ensure => 'present',
  }

  if ($::selinux != "false") {
    selboolean { 'virt_use_nfs':
        value => on,
        persistent => true,
    } -> Package['nfs-utils']
  }
}
