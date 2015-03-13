define quickstack::eqlx::volume (
  $index,
  $backend_section_name_array,
  $backend_eqlx_name_array,
  $san_ip_array,
  $san_login_array,
  $san_password_array,
  $san_thin_provision_array,
  $eqlx_group_name_array,
  $eqlx_pool_array,
  $eqlx_use_chap_array,
  $eqlx_chap_login_array,
  $eqlx_chap_password_array
) {

  if($index >= 0)
  {
    $backend_section_name = $backend_section_name_array[$index]
    $backend_eqlx_name = $backend_eqlx_name_array[$index]
    $san_ip = $san_ip_array[$index]
    $san_login = $san_login_array[$index]
    $san_password = $san_password_array[$index]
    $san_thin_provision = $san_thin_provision_array[$index]
    $eqlx_group_name = $eqlx_group_name_array[$index]
    $eqlx_pool = $eqlx_pool_array[$index]
    $eqlx_use_chap = $eqlx_use_chap_array[$index]
    $eqlx_chap_login = $eqlx_chap_login_array[$index]
    $eqlx_chap_password = $eqlx_chap_password_array[$index]

    cinder::backend::eqlx { $backend_section_name:
      volume_backend_name => $backend_eqlx_name,
      san_ip             => $san_ip,
      san_login          => $san_login,
      san_password       => $san_password,
      san_thin_provision => $san_thin_provision,
      eqlx_group_name    => $eqlx_group_name,
      eqlx_pool          => $eqlx_pool,
      eqlx_use_chap      => str2bool_i(strip("$eqlx_use_chap")),
      eqlx_chap_login    => $eqlx_chap_login,
      eqlx_chap_password => $eqlx_chap_password,
    }

    #recurse
    $next = $index -1
    quickstack::eqlx::volume {$next:
      index => $next,
      backend_section_name_array => $backend_section_name_array,
      backend_eqlx_name_array => $backend_eqlx_name_array,
      san_ip_array => $san_ip_array,
      san_login_array => $san_login_array,
      san_password_array => $san_password_array,
      san_thin_provision_array => $san_thin_provision_array,
      eqlx_group_name_array => $eqlx_group_name_array,
      eqlx_pool_array => $eqlx_pool_array,
      eqlx_use_chap_array => $eqlx_use_chap_array,
      eqlx_chap_login_array => $eqlx_chap_login_array,
      eqlx_chap_password_array => $eqlx_chap_password_array
   }
  }
}
