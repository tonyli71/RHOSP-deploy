# quickstack gluster volume class
class quickstack::storage_backend::gluster::volume_cinder (
  $cinder_gluster_path          = $quickstack::params::cinder_gluster_path,
  $cinder_gluster_peers         = $quickstack::params::cinder_gluster_peers,
  $cinder_gluster_replica_count = $quickstack::params::cinder_gluster_replica_count,
  $cinder_gluster_volume        = $quickstack::params::cinder_gluster_volume,
) inherits quickstack::params {
  volume { $cinder_gluster_volume:
    ensure         => present,
    path           => $cinder_gluster_path,
    peers          => $cinder_gluster_peers,
    replica_count  => $cinder_gluster_replica_count,
  }
}
