class quickstack::neutron::firewall::gre (
) {
  include quickstack::firewall::common

  firewall { '002 gre':
    proto  => 'gre',
    action => 'accept',
  }
}
