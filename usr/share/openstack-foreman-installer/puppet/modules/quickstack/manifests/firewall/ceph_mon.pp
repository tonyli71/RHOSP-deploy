class quickstack::firewall::ceph_mon (
  $ports = ['6789'],
  $proto = 'tcp',
) {

  include quickstack::firewall::common

  firewall { '001 ceph mon incoming':
    proto  => $proto,
    dport  => $ports,
    action => 'accept',
  }
}
