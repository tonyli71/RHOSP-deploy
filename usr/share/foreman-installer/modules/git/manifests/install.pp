# = Class: git::install
#
# Installs required packages for git.
#
#
class git::install {
  require git::params

  package { $git::params::package:
    ensure => installed,
  }
}
