class quickstack::firewall::keystone (
  $public_port = '5000',
  $admin_port = '35357',
) {

  include quickstack::firewall::common

  firewall { '001 keystone incoming':
    proto  => 'tcp',
    dport  => ["$public_port", "$admin_port"],
    action => 'accept',
  }
}
