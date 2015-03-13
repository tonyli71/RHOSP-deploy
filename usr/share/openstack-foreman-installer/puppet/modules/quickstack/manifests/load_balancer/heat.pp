class quickstack::load_balancer::heat (
  $frontend_heat_pub_host,
  $frontend_heat_priv_host,
  $frontend_heat_admin_host,
  $frontend_heat_cfn_pub_host,
  $frontend_heat_cfn_priv_host,
  $frontend_heat_cfn_admin_host,
  $backend_server_names,
  $backend_server_addrs,
  $heat_cfn_enabled         = true,
  $heat_cloudwatch_enabled  = true,
  $heat_port                = '8004',
  $heat_mode                = 'tcp',
  $heat_cfn_port            = '8000',
  $heat_cfn_mode            = 'tcp',
  $heat_cloudwatch_port     = '8003',
  $heat_cloudwatch_mode     = 'tcp',
  $log                      = 'tcplog',
) {

  include quickstack::load_balancer::common

  quickstack::load_balancer::proxy { 'heat-api':
    addr                 => [ $frontend_heat_pub_host,
                              $frontend_heat_priv_host,
                              $frontend_heat_admin_host ],
    port                 => "$heat_port",
    mode                 => "$heat_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }

  if str2bool_i($heat_cfn_enabled) {
    quickstack::load_balancer::proxy { 'heat-cfn':
      addr                 => [ $frontend_heat_cfn_pub_host,
                                $frontend_heat_cfn_priv_host,
                                $frontend_heat_cfn_admin_host ],
      port                 => "$heat_cfn_port",
      mode                 => "$heat_cfn_mode",
      listen_options       => { 'option' => [ "$log" ] },
      member_options       => [ 'check inter 1s' ],
      backend_server_addrs => $backend_server_addrs,
      backend_server_names => $backend_server_names,
    }
  }

  if str2bool_i($heat_cloudwatch_enabled) {
    quickstack::load_balancer::proxy { 'heat-cloudwatch':
      # only supposed to be used internally by heat-engine
      addr                 => [ $frontend_heat_priv_host,
                                $frontend_heat_admin_host ],
      port                 => "$heat_cloudwatch_port",
      mode                 => "$heat_cloudwatch_mode",
      listen_options       => { 'option' => [ "$log" ] },
      member_options       => [ 'check inter 1s' ],
      backend_server_addrs => $backend_server_addrs,
      backend_server_names => $backend_server_names,
    }
  }
}
