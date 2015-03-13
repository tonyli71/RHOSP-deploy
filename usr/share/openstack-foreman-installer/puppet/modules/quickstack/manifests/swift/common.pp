class quickstack::swift::common (
  $swift_shared_secret,
) {

    #### Common ####
    class { 'ssh::server::install': }

    Class['swift'] -> Service <| |>
    class { 'swift':
        swift_hash_suffix => $swift_shared_secret,
        package_ensure    => latest,
    }

}
