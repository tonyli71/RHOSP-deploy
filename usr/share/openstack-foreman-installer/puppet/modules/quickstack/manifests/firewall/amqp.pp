class quickstack::firewall::amqp(
  $ports = ['5672'],
) {

  include quickstack::firewall::common

  firewall { '001 amqp incoming':
    proto  => 'tcp',
    dport  => $ports,
    action => 'accept',
  }
}
