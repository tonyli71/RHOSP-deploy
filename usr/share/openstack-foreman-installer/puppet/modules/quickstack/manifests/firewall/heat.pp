class quickstack::firewall::heat (
  $heat_enabled             = true,
  $heat_api_port            = '8004',

  $heat_cfn_enabled         = true,
  $heat_cfn_api_port        = '8000',

  $heat_cloudwatch_enabled  = true,
  $heat_cloudwatch_api_port = '8003',
) {

  include quickstack::firewall::common

  $heat_api_ensure = str2bool_i("$heat_enabled") ? {
    true  => 'present',
    false => 'absent',
  }
  $heat_cfn_api_ensure = str2bool_i("$heat_cfn_enabled") ? {
    true  => 'present',
    false => 'absent',
  }
  $heat_cloudwatch_api_ensure = str2bool_i("$heat_cloudwatch_enabled") ? {
    true  => 'present',
    false => 'absent',
  }

  firewall { '001 heat incoming':
    proto  => 'tcp',
    dport  => ["$heat_api_port"],
    action => 'accept',
    ensure => $heat_api_ensure,
  }

  firewall { '001 heat cfn incoming':
    proto  => 'tcp',
    dport  => ["$heat_cfn_api_port"],
    action => 'accept',
    ensure => $heat_cfn_api_ensure,
  }

  firewall { '001 heat cloudwatch incoming':
    proto  => 'tcp',
    dport  => ["$heat_cloudwatch_api_port"],
    action => 'accept',
    ensure => $heat_cloudwatch_api_ensure,
  }
}
