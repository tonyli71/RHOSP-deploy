class quickstack::firewall::glance (
  $ports = ['9191','9292'],
  $proto = 'tcp',
) {

  include quickstack::firewall::common

  firewall { '001 glance incoming':
    proto  => $proto,
    dport  => $ports,
    action => 'accept',
  }
}
