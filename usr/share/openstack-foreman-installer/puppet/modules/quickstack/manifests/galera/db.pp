class quickstack::galera::db (
  $keystone_db_user       = 'keystone',
  $keystone_db_dbname     = 'keystone',
  $keystone_db_password,
  $glance_db_user         = 'glance',
  $glance_db_dbname       = 'glance',
  $glance_db_password,
  $nova_db_user           = 'nova',
  $nova_db_dbname         = 'nova',
  $nova_db_password,
  $heat_db_user           = 'heat',
  $heat_db_dbname         = 'heat',
  $heat_db_password,
  $cinder_db_user         = 'cinder',
  $cinder_db_dbname       = 'cinder',
  $cinder_db_password,
  $neutron_db_user        = 'neutron',
  $neutron_db_dbname      = 'neutron',
  $neutron_db_password,
) {

  database { $keystone_db_dbname:
    ensure   => 'present',
    provider => 'mysql',
  }
  database_user { "$keystone_db_user@%":
    ensure => 'present',
    password_hash => mysql_password("$keystone_db_password"),
    provider      => 'mysql',
    require => Database[$keystone_db_dbname],
  }
  database_grant { "$keystone_db_user@%/$keystone_db_dbname":
    privileges => 'all',
    provider   => 'mysql',
    require    => Database_user["$keystone_db_user@%"]
  }

  database { $glance_db_dbname:
    ensure => 'present',
    provider => 'mysql',
  }
  database_user { "$glance_db_user@%":
    ensure => 'present',
    password_hash => mysql_password("$glance_db_password"),
    provider      => 'mysql',
    require => Database[$glance_db_dbname],
  }
  database_grant { "$glance_db_user@%/$glance_db_dbname":
    privileges => 'all',
    provider   => 'mysql',
    require    => Database_user["$glance_db_user@%"]
  }

  database { $nova_db_dbname:
    ensure => 'present',
    provider => 'mysql',
  }
  database_user { "$nova_db_user@%":
    ensure => 'present',
    password_hash => mysql_password("$nova_db_password"),
    provider      => 'mysql',
    require => Database[$nova_db_dbname],
  }
  database_grant { "$nova_db_user@%/$nova_db_dbname":
    privileges => 'all',
    provider   => 'mysql',
    require    => Database_user["$nova_db_user@%"]
  }
  
  database { $cinder_db_dbname:
    ensure => 'present',
    provider => 'mysql',
  }
  database_user { "$cinder_db_user@%":
    ensure => 'present',
    password_hash => mysql_password("$cinder_db_password"),
    provider      => 'mysql',
    require => Database[$cinder_db_dbname],
  }
  database_grant { "$cinder_db_user@%/$cinder_db_dbname":
    privileges => 'all',
    provider   => 'mysql',
    require    => Database_user["$cinder_db_user@%"]
  }

  database { $heat_db_dbname:
    ensure => 'present',
    provider => 'mysql',
  }
  database_user { "$heat_db_user@%":
    ensure => 'present',
    password_hash => mysql_password("$heat_db_password"),
    provider      => 'mysql',
    require => Database[$heat_db_dbname],
  }
  database_grant { "$heat_db_user@%/$heat_db_dbname":
    privileges => 'all',
    provider   => 'mysql',
    require    => Database_user["$heat_db_user@%"]
  }
  
  database { $neutron_db_dbname:
    ensure => 'present',
    provider => 'mysql',
  }
  database_user { "$neutron_db_user@%":
    ensure => 'present',
    password_hash => mysql_password("$neutron_db_password"),
    provider      => 'mysql',
    require => Database[$neutron_db_dbname],
  }
  database_grant { "$neutron_db_user@%/$neutron_db_dbname":
    privileges => 'all',
    provider   => 'mysql',
    require    => Database_user["$neutron_db_user@%"]
  }

  Database_grant <| |> -> Exec["all-galera-nodes-are-up"]  
}
