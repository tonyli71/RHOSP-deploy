define quickstack::load_balancer::proxy (
  $addr,
  $port,
  $mode,
  $listen_options,
  $member_options,
  $define_cookies = false,
  $backend_server_names,
  $backend_server_addrs,
  $maxconn = 10000,
  $backend_port = '',
) {

  haproxy::listen { $name:
    ipaddress        => $addr,
    ports            => $port,
    mode             => $mode,
    options          => $listen_options,
    collect_exported => false,
  }

  $balancermember_port = $backend_port ? {
    '' => $port,
    default => $backend_port,
  }

  haproxy::balancermember { $name:
    listening_service => $name,
    ports             => $balancermember_port,
    server_names      => $backend_server_names,
    ipaddresses       => $backend_server_addrs,
    options           => $member_options,
    define_cookies    => $define_cookies,
  }
}
