class quickstack::firewall::nova (
  $api_port         = '8774',
  $metadata_port    = '8775',
  $novncproxy_port  = '6080',
  $xvpvncproxy_port = '6081',
) {

  include quickstack::firewall::common

  firewall { '001 nova incoming':
    proto  => 'tcp',
    dport  => ["$api_port", "$metadata_port",
              "$novncproxy_port", "$xvpvncproxy_port"],
    action => 'accept',
  }
}
