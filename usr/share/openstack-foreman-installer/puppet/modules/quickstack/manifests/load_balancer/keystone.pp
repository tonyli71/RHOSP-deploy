class quickstack::load_balancer::keystone (
  $frontend_pub_host,
  $frontend_priv_host,
  $frontend_admin_host,
  $backend_server_names,
  $backend_server_addrs,
  $public_port = '5000',
  $public_mode = 'tcp',
  $admin_port = '35357',
  $admin_mode = 'tcp',
  $log = 'tcplog',
) {

  include quickstack::load_balancer::common

  quickstack::load_balancer::proxy { 'keystone-public':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$public_port",
    mode                 => "$public_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }

  quickstack::load_balancer::proxy { 'keystone-admin':
    addr                 => [ $frontend_pub_host,
                              $frontend_priv_host,
                              $frontend_admin_host ],
    port                 => "$admin_port",
    mode                 => "$admin_mode",
    listen_options       => { 'option' => [ "$log" ] },
    member_options       => [ 'check inter 1s' ],
    backend_server_addrs => $backend_server_addrs,
    backend_server_names => $backend_server_names,
  }
}

