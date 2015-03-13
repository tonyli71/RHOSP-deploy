class quickstack::galera::server (
  $mysql_bind_address      = '0.0.0.0',
  $mysql_root_password     = '',
  $galera_bootstrap        = false,
  $galera_monitor_username = 'monitor_user',
  $galera_monitor_password = 'monitor_pass',
  $service_enable          = true,
  $service_ensure          = true,
  $wsrep_cluster_name      = 'galera_cluster',
  $wsrep_cluster_members   = [],
  $wsrep_sst_method        = 'rsync',
  $wsrep_sst_username      = 'sst_user',
  $wsrep_sst_password      = 'sst_pass',
  $wsrep_ssl               = true,
  $wsrep_ssl_key           = '/etc/pki/galera/galera.key',
  $wsrep_ssl_cert          = '/etc/pki/galera/galera.crt',
){
  class {'::galera::server':
    bootstrap => $galera_bootstrap,
    config_hash => {
      bind_address   => $mysql_bind_address,
      root_password  => $mysql_root_password,
      default_engine => 'InnoDB',
      restart => false,
    },
    service_enable        => $service_enable,
    service_ensure        => $service_ensure,
    wsrep_bind_address    => $mysql_bind_address,
    wsrep_cluster_name    => $wsrep_cluster_name,
    wsrep_cluster_members => $wsrep_cluster_members,
    wsrep_sst_method      => $wsrep_sst_method,
    wsrep_sst_username    => $wsrep_sst_username,
    wsrep_sst_password    => $wsrep_sst_password,
    wsrep_ssl             => $wsrep_ssl,
    wsrep_ssl_key         => $wsrep_ssl_key,
    wsrep_ssl_cert        => $wsrep_ssl_cert,
  }
  contain galera::server

  class {'::galera::monitor':
    mysql_username => $galera_monitor_username,
    mysql_password => $galera_monitor_password,
    mysql_host     => 'localhost',
  }
}
