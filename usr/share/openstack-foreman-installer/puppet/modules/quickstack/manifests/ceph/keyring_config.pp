define quickstack::ceph::keyring_config (
  $key = '',
) {
  $keyring_name = $title
  file { "etc-ceph-keyring-${keyring_name}":
    path => "/etc/ceph/ceph.client.${keyring_name}.keyring",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('quickstack/ceph-keyring.erb'),
  }
}
