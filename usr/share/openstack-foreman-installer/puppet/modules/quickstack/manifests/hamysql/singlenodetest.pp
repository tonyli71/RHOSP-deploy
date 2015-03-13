class quickstack::hamysql::singlenodetest (
  # just set up a single node (non-HA) quickstack::db::mysql db
  # these params aren't doing anything yet
  $mysql_root_password         = $quickstack::params::mysql_root_password,
  $keystone_db_password        = $quickstack::params::keystone_db_password,
  $glance_db_password          = $quickstack::params::glance_db_password,
  $nova_db_password            = $quickstack::params::nova_db_password,
  $neutron_db_password         = '',
  $cinder_db_password          = $quickstack::params::cinder_db_password,
  $heat_db_password            = $quickstack::params::heat_db_password,
  $keystone_db_user            = 'keystone',
  $keystone_db_dbname          = 'keystone',
  $mysql_bind_address          = '0.0.0.0'
) inherits quickstack::params {

  class {'quickstack::db::mysql':
      mysql_root_password  => $mysql_root_password,
      keystone_db_password => $keystone_db_password,
      glance_db_password   => $glance_db_password,
      nova_db_password     => $nova_db_password,
      cinder_db_password   => $cinder_db_password,
      neutron_db_password  => $neutron_db_password,

      # MySQL
      mysql_bind_address     => '0.0.0.0',
      mysql_account_security => true,

      # neutron
      neutron                => true,

      allowed_hosts          => '%',
      enabled                => true,
  }

  class {'heat::db::mysql':
    password => $heat_db_password,
    allowed_hosts => "%%",
  }

  firewall {'020 mysql incoming':
    proto  => 'tcp',
    dport  => ["3306"],
    action => 'accept',
  }
}
