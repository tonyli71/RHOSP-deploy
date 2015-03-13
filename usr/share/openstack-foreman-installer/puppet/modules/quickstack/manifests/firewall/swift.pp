class quickstack::firewall::swift (
  $ports = ['8080'],
  $proto = 'tcp',
) {

  include quickstack::firewall::common

  firewall { '001 swift incoming':
    proto  => $proto,
    dport  => $ports,
    action => 'accept',
  }
}
