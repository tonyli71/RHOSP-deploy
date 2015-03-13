class quickstack::pacemaker::rabbitmq (
  $haproxy_timeout       = '900m',
  $inet_dist_listen      = '35672'
) {

  include quickstack::pacemaker::common

  if (str2bool_i(map_params('include_amqp')) and
      map_params('amqp_provider') == 'rabbitmq') {
    $amqp_group = map_params("amqp_group")
    $amqp_username = map_params("amqp_username")
    $amqp_password = map_params("amqp_password")
    $amqp_vip = map_params("amqp_vip")
    $cluster_nodes = regsubst(map_params("lb_backend_server_names"), '\..*', '')

    if ($::pcs_setup_rabbitmq ==  undef or
        !str2bool_i("$::pcs_setup_rabbitmq")) {
      $_enabled = true
    } else {
      $_enabled = false
    }

    class {'::quickstack::firewall::amqp':
      ports => [ map_params("amqp_port"), "${inet_dist_listen}", 4369 ]
    }

    class {"::rabbitmq":
      config_kernel_variables  => {'inet_dist_listen_min' => "${inet_dist_listen}",
                                  'inet_dist_listen_max' => "${inet_dist_listen}"},
      wipe_db_on_cookie_change => true,
      config_cluster           => true,
      cluster_nodes            => $cluster_nodes,
      node_ip_address          => map_params("local_bind_addr"),
      port                     => map_params("amqp_port"),
      default_user             => $amqp_username,
      default_pass             => $amqp_password,
      admin_enable             => false,
      package_provider         => "yum",
      package_source           => undef,
      manage_repos             => false,
      service_manage           => $_enabled,
    }

    class {'::quickstack::load_balancer::amqp':
      frontend_host        => $amqp_vip,
      backend_server_names => map_params("lb_backend_server_names"),
      backend_server_addrs => map_params("lb_backend_server_addrs"),
      port                 => map_params("amqp_port"),
      backend_port         => map_params("amqp_port"),
      timeout              => $haproxy_timeout,
    }

    Class['::quickstack::firewall::amqp'] ->
    Class['::quickstack::pacemaker::common'] ->
    # below creates just one vip (not three)
    quickstack::pacemaker::vips { "$amqp_group":
      public_vip  => $amqp_vip,
      private_vip => $amqp_vip,
      admin_vip   => $amqp_vip,
    } ->

    Class['::rabbitmq'] ->
    exec {"rabbit-mirrored-queues":
      command => '/usr/sbin/rabbitmqctl set_policy HA \'^(?!amq\.).*\' \'{"ha-mode": "all"}\'',
      unless  => '/usr/sbin/rabbitmqctl list_policies | grep -q HA',
      require => Class['::rabbitmq::service'],
    } ->
    Class['::quickstack::load_balancer::amqp'] ->

    exec {"pcs-rabbitmq-server-set-up":
      command => "/usr/sbin/pcs property set rabbitmq=running --force",
    } ->
    exec {"pcs-rabbitmq-server-set-up-on-this-node":
      command => "/tmp/ha-all-in-one-util.bash update_my_node_property rabbitmq"
    } ->
    exec {"all-rabbitmq-nodes-are-up":
      timeout   => 3600,
      tries     => 360,
      try_sleep => 10,
      command   => "/tmp/ha-all-in-one-util.bash all_members_include rabbitmq",
    } ->
    quickstack::pacemaker::manual_service { "rabbitmq-server":
      stop => !$_enabled,
    } ->
    quickstack::pacemaker::resource::service { 'rabbitmq-server':
      monitor_params => {"start-delay" => "35s"},
      clone          => true,
    }

    $_nodes = map_params('lb_backend_server_addrs')
    $first_node = $_nodes[0]
    unless has_interface_with("ipaddress", $first_node) {
      # This is very subtle but important.  The node that is first in
      # lb_backend_server_names needs to come up first.  The names
      # array and the addrs array are ordered the same, e.g. names[i]
      # is the same host as addrs[i] for all i.  So the IP we pull off
      # the front of addrs will be on the first host in names.  This
      # matters because the names array is what generates the
      # cluster_nodes value in the rabbitmq config.  When a node
      # starts the first time and it is configured to cluster, it
      # tries to join each node in cluster_nodes in succession.
      # Whichever node is first to start will try to join a cluster
      # with the others, time out against each, and then start a new
      # cluster with only itself as a member.  Each additional host to
      # start will then try each host in order until it get to a node
      # which has already been started, and join the cluster.
      #
      # However, there is a problem if the first node to start is not
      # the first node in the list.  Suppose the third node in the
      # list starts first, and then the first two nodes in the list
      # start up in parallel.  The first node will attempt to cluster
      # with the second node (it realizes that the first node is
      # itself and skips it).  The second node tries to cluster with
      # the first node.  Because neither host has an initialized
      # cluster, the clustering operation will fail on both nodes.
      #
      # By forcing the first node in the config to come up first, the
      # others can be started in parallel and be guaranteed to join
      # the cluster via the first node and its running cluster.
      exec {"i-am-first-rabbitmq-node-OR-rabbitmq-is-up-on-first-node":
        timeout   => 3600,
        tries     => 360,
        try_sleep => 10,
        command   => "/tmp/ha-all-in-one-util.bash property_exists rabbitmq",
        unless    => "/tmp/ha-all-in-one-util.bash property_exists rabbitmq",
        require   => Quickstack::Pacemaker::Vips ["$amqp_group"],
        before    => Class['::rabbitmq'],
      }
    }
  }
}
