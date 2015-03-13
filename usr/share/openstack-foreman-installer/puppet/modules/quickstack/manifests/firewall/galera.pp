class quickstack::firewall::galera (
  $mysql_port      = '3306',
  $monitor_port    = '9200',
  $galera_port     = '4567',
  $galera_ist_port = '4568',
  $galera_sst_port = '4444',
) {

  include quickstack::firewall::common

  firewall { '001 galera incoming':
    proto  => 'tcp',
    dport  => ["$mysql_port", "$monitor_port", "$galera_port", "$galera_ist_port", "$galera_sst_port" ],
    action => 'accept',
  }
}
