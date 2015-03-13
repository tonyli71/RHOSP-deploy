class quickstack::firewall::ceph_osd (
  $ports = ['6800-6810'],
  $proto = 'tcp',
) {

  include quickstack::firewall::common

  firewall { '001 ceph osd incoming':
    proto  => $proto,
    dport  => $ports,
    action => 'accept',
  }
}
