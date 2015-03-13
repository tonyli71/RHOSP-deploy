# quickstack gluster volume class
class quickstack::storage_backend::gluster::volume_glance (
  $glance_gluster_path          = $quickstack::params::glance_gluster_path,
  $glance_gluster_peers         = $quickstack::params::glance_gluster_peers,
  $glance_gluster_replica_count = $quickstack::params::glance_gluster_replica_count,
  $glance_gluster_volume        = $quickstack::params::glance_gluster_volume,
) inherits quickstack::params {
  volume { $glance_gluster_volume:
    ensure         => present,
    path           => $glance_gluster_path,
    peers          => $glance_gluster_peers,
    replica_count  => $glance_gluster_replica_count,
  }
}
