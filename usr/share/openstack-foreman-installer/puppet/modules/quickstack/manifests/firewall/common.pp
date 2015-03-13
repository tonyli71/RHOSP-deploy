class quickstack::firewall::common {

  # for any Fedora, and for Enterprise Linux > 6
  if ($::operatingsystem == 'Fedora' or
      ($::operatingsystem != 'Fedora' and $::operatingsystemmajrelease > 6)) {
    # Uninstall firewalld since everything uses iptables for now
    package { 'firewalld':
      ensure => "absent",
      before => Package['iptables-services'],
    }
  }

  class { 'firewall': }

  Service['iptables'] -> Firewall<||>
}
