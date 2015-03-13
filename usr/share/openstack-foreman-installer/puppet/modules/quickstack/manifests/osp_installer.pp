class quickstack::osp_installer(
  $repos_port = '81',
  $repos_path = '/var/www/html',
) {

  service { 'httpd':
        ensure => 'running',
        name   => 'httpd',
        enable => true,
      }

  service { 'named':
        ensure => 'running',
        name   => 'named',
        enable => true,
      }

  file { '/etc/httpd/conf.d/repos.conf':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/repos.conf.erb'),
    notify  => Service['httpd'],
  }

  file { '/etc/zones.conf':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('quickstack/zones.conf.erb'),
    notify  => Service['named'],
  }


}
