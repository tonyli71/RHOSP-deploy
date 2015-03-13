# == Type: quickstack::rsync::simple
#

# A type to setup a simple rsync server.  This exists because setting
# up multiple xinetd rsync servers on the same host (with different
# bind IP addrs) is not something easily acheived with ::rsync::server
# and ::xinetd.

# Warning, you will hit issues if you declare two quickstack::rsync::simple's
# with the same bind_addr.

define quickstack::rsync::simple (
  $service_name    = 'rsync',
  $disable         = 'no',
  $port            = '873',
  $socket_type     = 'stream',
  $protocol        = 'tcp',
  $wait            = 'no',
  $user            = 'root',
  $group           = 'root',
  $server          = '/usr/bin/rsync',
  $bind_addr       = '127.0.0.1',
  $server_args     = "--daemon --config /etc/rsync-$title.conf",
  $per_source      = '',
  $log_on_failure  = '',
  $cps             = '',
  $flags           = '',
  $service_type    = '',
  $use_chroot      = 'no',
  $section_name    = $title,
  $path            = '/',
  $read_only       = 'yes',
  $write_only      = 'no',
  $list            = 'yes',
  $uid             = 0,
  $gid             = 0,
  $incoming_chmod  = 0644,
  $outgoing_chmod  = 0644,
  $max_connections = 0,
  $lock_file       = '/var/run/rsync.lock',
  $comment         = '',
  $secrets_file    = '',
  $auth_users      = [],
  $hosts_allow     = [],
  $hosts_deny      = [],
) {
  include '::quickstack::rsync::common'

  file { "xinetd-rsync-$title":
    path    => "/etc/xinetd.d/rsync-$title",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('quickstack/xinetd-service.erb'),
  }
  ->
  file { "rsync-conf-$title":
    path    => "/etc/rsync-$title.conf",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('quickstack/rsync-conf.erb'),
  }
  ->
  # resorting to exec below because ~> Service['xinetd'] doesn't
  # force a restart
  exec { "restart-xinetd-$title":
    command     => "/sbin/service xinetd restart",
  }
}
