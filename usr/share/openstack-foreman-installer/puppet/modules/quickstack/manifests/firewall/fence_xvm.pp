class quickstack::firewall::fence_xvm (
  $port = '1229',
) {

  include quickstack::firewall::common

  firewall { '010 fence_xvm incoming':
    proto  => 'tcp',
    dport  => ["$port"],
    action => 'accept',
  }
}
