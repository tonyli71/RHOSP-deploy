# = Class: firewall::linux::redhat
#
# Manages the `iptables` service on RedHat-alike systems.
#
# == Parameters:
#
# [*ensure*]
#   Ensure parameter passed onto Service[] resources.
#   Default: running
#
# [*enable*]
#   Enable parameter passed onto Service[] resources.
#   Default: true
#
class firewall::linux::redhat (
  $ensure = running,
  $enable = true
) {

  $el_release = ['RedHat', 'CentOS']

  # RHEL 7 and later and Fedora 15 and later require the iptables-services
  # package, which provides the /usr/libexec/iptables/iptables.init used by
  # lib/puppet/util/firewall.rb.
  if $::operatingsystem in $el_release and $::operatingsystemmajrelease >= 7 {
    package { 'iptables-services':
      ensure => present,
      before => Service['iptables'],
    }
    Package['iptables-services'] -> Firewall <||>
  }

  if $::operatingsystem == Fedora and $::operatingsystemrelease >= 15 {
    package { 'iptables-services':
      ensure => present,
      before => Service['iptables'],
    }
    Package['iptables-services'] -> Firewall <||>
  }

  service { 'iptables':
    ensure    => $ensure,
    enable    => $enable,
    hasstatus => true,
    require   => File['/etc/sysconfig/iptables'],
  }

  file { '/etc/sysconfig/iptables':
    ensure => present,
    owner  => root,
    group  => root,
    mode   => 0600,
  }
}
