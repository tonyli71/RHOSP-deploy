class quickstack::firewall::memcached (
  $port = '11211',
) {

  include quickstack::firewall::common

  firewall { '010 memcached incoming':
    proto  => 'tcp',
    dport  => ["$port"],
    action => 'accept',
  }
}
