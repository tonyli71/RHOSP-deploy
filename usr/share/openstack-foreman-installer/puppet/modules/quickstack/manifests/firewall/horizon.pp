class quickstack::firewall::horizon (
  $http_port = '80',
  $ssl_port  = '443',
) {

  include quickstack::firewall::common

  firewall { '001 apache incoming':
    proto  => 'tcp',
    dport  => ["$http_port","$ssl_port"],
    action => 'accept',
  }
}
