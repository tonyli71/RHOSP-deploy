class quickstack::load_balancer::nova (
  $frontend_pub_host,
  $frontend_priv_host,
  $frontend_admin_host,
  $backend_server_names,
  $backend_server_addrs,
  $api_port         = '8774',
  $api_mode         = 'tcp',
  $metadata_port    = '8775',
  $metadata_mode    = 'tcp',
  $novncproxy_port  = '6080',
  $novncproxy_mode  = 'tcp',
  $xvpvncproxy_port = '6081',
  $xvpvncproxy_mode = 'tcp',
  $log = 'tcplog',
) {

  include quickstack::load_balancer::common

  quickstack::load_balancer::proxy { 'nova-api':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$api_port",
    mode                 => "$api_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }

  quickstack::load_balancer::proxy { 'nova-metadata':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$metadata_port",
    mode                 => "$metadata_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }

  quickstack::load_balancer::proxy { 'nova-novncproxy':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$novncproxy_port",
    mode                 => "$novncproxy_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }

  quickstack::load_balancer::proxy { 'nova-xvpvncproxy':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$xvpvncproxy_port",
    mode                 => "$xvpvncproxy_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }
}
