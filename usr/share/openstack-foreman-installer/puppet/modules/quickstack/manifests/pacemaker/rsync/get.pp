# Definition: rsync::get
#
# get files via rsync
#
# Parameters:
#   $source  - source to copy from
#   $path    - path to copy to, defaults to $name
#   $user    - username on remote system
#   $purge   - if set, rsync will use '--delete'
#   $override_options - additional options to pass to rsync
#   $exlude  - string to be excluded
#   $keyfile - path to ssh key used to connect to remote host, defaults to /home/${user}/.ssh/id_rsa
#   $timeout - timeout in seconds, defaults to 900
#
# Actions:
#   get files via rsync
#
# Requires:
#   $source must be set
#
# Sample Usage:
#
#  rsync::get { '/foo':
#    source  => "rsync://${rsyncServer}/repo/foo/",
#    require => File['/foo'],
#  } # rsync
#
define quickstack::pacemaker::rsync::get (
  $source,
  $path = undef,
  $user = undef,
  $purge = undef,
  $override_options = 'a',
  $exclude = undef,
  $keyfile = undef,
  $timeout = '900',
  $unless = '/bin/false',
) {

  include '::quickstack::rsync::common'

  if $keyfile {
    $Mykeyfile = $keyfile
  } else {
    $Mykeyfile = "/home/${user}/.ssh/id_rsa"
  }

  if $user {
    $MyUser = "-e 'ssh -i ${Mykeyfile} -l ${user}' ${user}@"
  }

  if $purge {
    $MyPurge = '--delete'
  }

  if $exclude {
    $MyExclude = "--exclude=${exclude}"
  }

  if $path {
    $MyPath = $path
  } else {
    $MyPath = $name
  }

  $rsync_options = "-${override_options} ${MyPurge} ${MyExclude} ${MyUser}${source} ${MyPath}"

  exec { "rsync ${name}":
    command   => "rsync -q ${rsync_options}",
    path      => [ '/bin', '/usr/bin' ],
    timeout   => $timeout,
    tries     => 360,
    try_sleep => 10,
    unless    => "$unless",
  }
}
