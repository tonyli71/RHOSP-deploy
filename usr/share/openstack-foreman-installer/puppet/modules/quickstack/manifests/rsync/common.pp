class quickstack::rsync::common ( ) {
  include ::xinetd

  package { 'rsync':
    ensure => installed,
  }

  firewall { '010 rsync incoming':
    proto  => 'tcp',
    dport  => ["873"],
    action => 'accept',
  }
}
