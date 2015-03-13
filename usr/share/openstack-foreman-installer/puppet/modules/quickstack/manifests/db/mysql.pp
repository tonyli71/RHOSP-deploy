#
# === Class: quickstack::db::mysql
#
# Create MySQL databases for all components of
# OpenStack that require a database. This started life as a duplicate of
# openstack::db::mysql, but needed features and changes that did not match the
# goals of that project.
#
# === Parameters
#
# [mysql_root_password] Root password for mysql. Required.
# [keystone_db_password] Password for keystone database. Required.
# [glance_db_password] Password for glance database. Required.
# [nova_db_password] Password for nova database. Required.
# [cinder_db_password] Password for cinder database. Required.
# [neutron_db_password] Password for neutron database. Required.
# [ceilometer_db_password] Password for ceilometer database. Required.
# [mysql_bind_address] Address that mysql will bind to. Optional .Defaults to '0.0.0.0'.
# [mysql_account_security] If a secure mysql db should be setup. Optional .Defaults to true.
# [mysql_ssl] Enable SSL in the mysql server. Default is false.
# [mysql_ca] The path to the CA certificate in PEM format.
# [mysql_cert] The path to the server certificate in PEM format.
# [mysql_key] The path to the server private key in PEM format, unencrypted.
# [mysql_default_engine] Whether to use MyIsam or InnoDB as the default engine.
# Optional, Defaults to 'InnoDB'.
# [keystone_db_user] DB user for keystone. Optional. Defaults to 'keystone'.
# [keystone_db_dbname] DB name for keystone. Optional. Defaults to 'keystone'.
# [glance_db_user] DB user for glance. Optional. Defaults to 'glance'.
# [glance_db_dbname]. Name of glance DB. Optional. Defaults to 'glance'.
# [nova_db_user]. Name of nova DB user. Optional. Defaults to 'nova'.
# [nova_db_dbname]. Name of nova DB. Optional. Defaults to 'nova'.
# [cinder]. Whether create cinder db. Optional. Defaults to 'true'.
# [cinder_db_user]. Name of cinder DB user. Optional. Defaults to 'cinder'.
# [cinder_db_dbname]. Name of cinder DB. Optional. Defaults to 'cinder'.
# [neutron]. Whether create neutron db. Optional. Defaults to 'true'.
# [neutron_db_user]. Name of neutron DB user. Optional. Defaults to 'neutron'.
# [neutron_db_dbname]. Name of neutron DB. Optional. Defaults to 'neutron'.
# [ceilometer]. Whether create ceilometer db. Optional. Defaults to 'true'.
# [ceilometer_db_user]. Name of ceilometer DB user. Optional. Defaults to 'ceilometer'.
# [ceilometer_db_dbname]. Name of ceilometer DB. Optional. Defaults to 'ceilometer'.
# [allowed_hosts] List of hosts that are allowed access. Optional. Defaults to false.
# [charset] Name of mysql charset. Optional. Defaults to 'utf8'.
# [enabled] If the db service should be started. Optional. Defaults to true.
#
# === Example
#
# class { 'quickstack::db::mysql':
#    mysql_root_password  => 'changeme',
#    keystone_db_password => 'changeme',
#    glance_db_password   => 'changeme',
#    nova_db_password     => 'changeme',
#    cinder_db_password   => 'changeme',
#    neutron_db_password  => 'changeme',
#    allowed_hosts        => ['127.0.0.1', '10.0.0.%'],
#  }
class quickstack::db::mysql (
    # Required MySQL
    # passwords
    $mysql_root_password,
    $keystone_db_password,
    $glance_db_password,
    $nova_db_password,
    $cinder_db_password,
    $neutron_db_password,
    $ceilometer_db_password = false,
    # MySQL
    $mysql_bind_address     = '0.0.0.0',
    $mysql_account_security = true,
    $mysql_ssl              = false,
    $mysql_ca               = undef,
    $mysql_cert             = undef,
    $mysql_key              = undef,
    $mysql_default_engine   = 'InnoDB',
    # Keystone
    $keystone_db_user       = 'keystone',
    $keystone_db_dbname     = 'keystone',
    # Glance
    $glance_db_user         = 'glance',
    $glance_db_dbname       = 'glance',
    # Nova
    $nova_db_user           = 'nova',
    $nova_db_dbname         = 'nova',
    # Cinder
    $cinder                 = true,
    $cinder_db_user         = 'cinder',
    $cinder_db_dbname       = 'cinder',
    # Neutron
    $neutron                = true,
    $neutron_db_user        = 'neutron',
    $neutron_db_dbname      = 'neutron',
    # Ceilometer
    $ceilometer             = false,
    $ceilometer_db_user     = 'ceilometer',
    $ceilometer_db_dbname   = 'ceilometer',
    # General
    $allowed_hosts          = false,
    $charset                = 'utf8',
    $enabled                = true,

    $wsrep_cluster_members  = [],
    $galera_bootstrap       = false,
    $wsrep_sst_username = 'wsrep_sst',
    $wsrep_sst_password = 'wspass',
    $galera_monitor_username = 'monitor_user',
    $galera_monitor_password = 'monitor_pass',
    $wsrep_node_address = $::ipaddress,
) {

  # Install and configure MySQL Server
  #class { '::mysql::server':
  #  config_hash        => {
  #    'root_password'  => $mysql_root_password,
  #    'bind_address'   => $mysql_bind_address,
  #    'default_engine' => $mysql_default_engine,
  #    'ssl'            => $mysql_ssl,
  #    'ssl_ca'         => $mysql_ca,
  #    'ssl_cert'       => $mysql_cert,
  #    'ssl_key'        => $mysql_key,
  #  },
  #  package_name => 'mariadb-galera-server',
  #  enabled      => $enabled,
  #}

  class { '::galera::server':
           config_hash => {
               bind_address   => $mysql_bind_address,
               default_engine => 'InnoDB',
               root_password  => $mysql_root_password,
           },
           wsrep_cluster_name   => 'galera_cluster',
           wsrep_sst_method     => 'rsync',
           wsrep_sst_username   => $wsrep_sst_username,
           wsrep_sst_password   => $wsrep_sst_password,
           wsrep_cluster_members => $wsrep_cluster_members,
           wsrep_node_address  => $wsrep_node_address, 
           bootstrap  => $galera_bootstrap,
    	   service_enable        => true,
    	   service_ensure        => true,
  	   wsrep_ssl               => false,
  	   wsrep_ssl_key           => '/etc/pki/galera/galera.key',
  	   wsrep_ssl_cert          => '/etc/pki/galera/galera.crt',
  }

  class {'::galera::monitor':
    mysql_username => $galera_monitor_username,
    mysql_password => $galera_monitor_password,
    mysql_host     => 'localhost',
  }

  # This removes default users and guest access
  if $mysql_account_security {
    class { '::mysql::server::account_security': }
  }

  if ($enabled) {
    # Create the Keystone db
    class { '::keystone::db::mysql':
      user          => $keystone_db_user,
      password      => $keystone_db_password,
      dbname        => $keystone_db_dbname,
      allowed_hosts => $allowed_hosts,
      charset       => $charset,
    }

    # Create the Glance db
    class { '::glance::db::mysql':
      user          => $glance_db_user,
      password      => $glance_db_password,
      dbname        => $glance_db_dbname,
      allowed_hosts => $allowed_hosts,
      charset       => $charset,
    }

    # Create the Nova db
    class { '::nova::db::mysql':
      user          => $nova_db_user,
      password      => $nova_db_password,
      dbname        => $nova_db_dbname,
      allowed_hosts => $allowed_hosts,
      charset       => $charset,
    }

    # create cinder db
    if ($cinder) {
      class { '::cinder::db::mysql':
        user          => $cinder_db_user,
        password      => $cinder_db_password,
        dbname        => $cinder_db_dbname,
        allowed_hosts => $allowed_hosts,
        charset       => $charset,
      }
    }

    # create neutron db
    if ($neutron) {
      class { '::neutron::db::mysql':
        user          => $neutron_db_user,
        password      => $neutron_db_password,
        dbname        => $neutron_db_dbname,
        allowed_hosts => $allowed_hosts,
        charset       => $charset,
      }
    }

    if ($ceilometer) {
      class { '::ceilometer::db::mysql':
        user          => $ceilometer_db_user,
        password      => $ceilometer_db_password,
        dbname        => $ceilometer_db_dbname,
        allowed_hosts => $allowed_hosts,
        charset       => $charset,
      }
    }
  }
}
