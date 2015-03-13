class quickstack::neutron::notifications(
) {
  include quickstack::pacemaker::params

  $nova_admin_vip     = map_params('nova_admin_vip')
  $keystone_admin_vip = map_params('keystone_admin_vip')
  $nova_group         = map_params('nova_group')
  $nova_user_password = map_params('nova_user_password')

  class { '::neutron::server::notifications':
    notify_nova_on_port_status_changes => true,
    notify_nova_on_port_data_changes   => true,
    nova_url                           => "http://${nova_admin_vip}:8774/v2",
    nova_admin_auth_url                => "http://${keystone_admin_vip}:35357/v2.0",
    nova_admin_username                => "${nova_group}",
    nova_admin_password                => "${nova_user_password}",
  }
}
