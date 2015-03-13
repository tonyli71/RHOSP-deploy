class quickstack::horizon(
    $bind_address          = '0.0.0.0',
    $cache_server_ip       = '127.0.0.1',
    $cache_server_port     = '11211',
    $enabled               = true,
    $ensure                = 'running',
    $fqdn                  = $::fqdn,
    $horizon_cert          = undef,
    $horizon_key           = undef,
    $horizon_ca            = undef,
    $keystone_default_role = 'Member',
    $keystone_host         = '127.0.0.1',
    $listen_ssl            = 'false',
    $memcached_servers     = undef,
    $secret_key,
) {

  include ::memcached

  # horizon packages
  package {'python-memcached':
    ensure => installed,
  }~>
  package {'python-netaddr':
    ensure => installed,
    notify => Class['::horizon'],
  }

  file {'/etc/httpd/conf.d/rootredirect.conf':
    ensure  => present,
    content => 'RedirectMatch ^/$ /dashboard/',
    notify  => File['/etc/httpd/conf.d/openstack-dashboard.conf'],
  }

  if str2bool_i("$listen_ssl") {
    apache::listen { '443': }
  }

  # needed for https://bugzilla.redhat.com/show_bug.cgi?id=1111656
  class { 'apache':
    default_vhost  => false,
    service_enable => str2bool_i("$enabled"),
    service_ensure => $ensure,
  }

  class {'::horizon':
    bind_address          => $bind_address,
    cache_server_ip       => $cache_server_ip,
    cache_server_port     => $cache_server_port,
    fqdn                  => $fqdn,
    keystone_default_role => $keystone_default_role,
    keystone_host         => $keystone_host,
    horizon_cert          => $horizon_cert,
    horizon_key           => $horizon_key,
    horizon_ca            => $horizon_ca,
    listen_ssl            => str2bool_i("$listen_ssl"),
    secret_key            => $horizon_secret_key,
  }

# Concat::Fragment['Apache ports header'] ->
# File_line['ports_listen_on_bind_address_80']
# TODO: add a file_line to set array of memcached servers
# the above is an example of the required ordering

  if ($::selinux != "false"){
    selboolean { 'httpd_can_network_connect':
      value => on,
      persistent => true,
    }
  }

  class {'::quickstack::firewall::horizon':}

  $neutron_core_plugin = $::quickstack::neutron::plugins::cisco::neutron_core_plugin

  if $neutron_core_plugin == 'neutron.plugins.cisco.network_plugin.PluginV2' {
    $neutron_defaults                   = {'enable_lb' => false, 'enable_firewall' => false, 'enable_quotas' => true, 'enable_security_group' => true, 'enable_vpn' => false, 'profile_support' => 'None' }
    $neutron_options                    = {'enable_lb' => true, 'enable_firewall' => true, 'enable_quotas' => false, 'enable_security_group' => false, 'enable_vpn' => true, 'profile_support' => 'cisco' }
    $openstack_endpoint_type            = undef
    $compress_offline                   = True
    $file_upload_temp_dir               = '/tmp'
    $available_regions                  = undef
    $hypervisor_options                 = {'can_set_mount_point' => false, 'can_set_password' => true }
    $hypervisor_defaults                = {'can_set_mount_point' => $can_set_mount_point, 'can_set_password'  => false }
    $django_debug                       = 'False'
    $api_result_limit                   = '1000'
    $help_url                           = 'http://docs.openstack.org'
    $keystone_port                      = '5000'
    $keystone_scheme                    = 'http'
    $can_set_mount_point                = 'True'
    $log_level                          = 'DEBUG'
    $horizon_app_links                  = 'False'
    file {'/usr/share/openstack-dashboard/openstack_dashboard/local/local_settings.py':
      content => template('/usr/share/openstack-puppet/modules/horizon/templates/local_settings.py.erb')
    } ~> Service['httpd']

    $disable_router    = 'False'
    Neutron_plugin_cisco<||> ->
    file {'/usr/share/openstack-dashboard/openstack_dashboard/enabled/_40_router.py':
      content => template('quickstack/_40_router.py.erb')
    } ~> Service['httpd']
  }
}
