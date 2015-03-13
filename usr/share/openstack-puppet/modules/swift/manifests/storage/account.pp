class swift::storage::account(
  $manage_service = true,
  $enabled        = true,
  $package_ensure = 'present'
) {
  swift::storage::generic { 'account':
    manage_service => $manage_service,
    enabled        => $enabled,
    package_ensure => $package_ensure,
  }

  include swift::params

  if $manage_service {
    if $enabled {
      $service_ensure = 'running'
    } else {
      $service_ensure = 'stopped'
    }
  }

  service { 'swift-account-reaper':
    ensure    => $service_ensure,
    name      => $::swift::params::account_reaper_service_name,
    enable    => $enabled,
    provider  => $::swift::params::service_provider,
    require   => Package['swift-account'],
  }

  service { 'swift-account-auditor':
    ensure    => $service_ensure,
    name      => $::swift::params::account_auditor_service_name,
    enable    => $enabled,
    provider  => $::swift::params::service_provider,
    require   => Package['swift-account'],
  }
}
