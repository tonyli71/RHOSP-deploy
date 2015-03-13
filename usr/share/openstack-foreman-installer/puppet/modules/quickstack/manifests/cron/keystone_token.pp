class quickstack::cron::keystone_token {
  # Run token flush every minute (without output so we won't spam admins)
  # This seems like something that should be in puppet-keystone, but since it is
  # not, adding to quickstack.
  cron { 'token-flush':
    ensure  => 'present',
    command => '/usr/bin/keystone-manage token_flush >/dev/null 2>&1',
    minute  => '*/1',
    user    => 'keystone',
    require => [User['keystone'], Group['keystone']],
    } ->

    service { 'crond':
      ensure => 'running',
      enable => true,
    }
}
