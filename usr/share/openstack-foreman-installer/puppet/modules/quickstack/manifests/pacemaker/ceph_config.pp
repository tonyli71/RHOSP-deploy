class quickstack::pacemaker::ceph_config {

  include quickstack::pacemaker::common

  class { '::quickstack::ceph::config':
    fsid                  => map_params('ceph_fsid'),
    cluster_network       => map_params('ceph_cluster_network'),
    public_network        => map_params('ceph_public_network'),
    mon_initial_members   => map_params('ceph_mon_initial_members'),
    mon_host              => map_params('ceph_mon_host'),
    images_key            => map_params('ceph_images_key'),
    volumes_key           => map_params('ceph_volumes_key'),
    osd_pool_default_size => map_params('ceph_osd_pool_size'),
    osd_journal_size      => map_params('ceph_osd_journal_size'),
  }
}
