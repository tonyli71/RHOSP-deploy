class quickstack::firewall::iscsi (
  $port = '3260',
) {

  include quickstack::firewall::common

  firewall { '010 iscsi incoming':
    proto  => 'tcp',
    dport  => ["$port"],
    action => 'accept',
  }
}
