class quickstack::neutron::plugins::nova_config (
  $nova_conf_additional_params  = { quota_instances => 'default',
                                    quota_cores => 'default',
                                    quota_ram => 'default',
                                    quota_floating_ips => 'default',
                                    quota_fixed_ips => 'default',
                                    quota_driver => 'default',
                                  },
) {

  if $nova_conf_additional_params[quota_instances] != 'default' {
    nova_config {
      'DEFAULT/quota_instances':      value => $nova_conf_additional_params[quota_instances];
    }
  }

  if $nova_conf_additional_params[quota_cores] != 'default' {
    nova_config {
      'DEFAULT/quota_cores':      value => $nova_conf_additional_params[quota_cores];
    }
  }

  if $nova_conf_additional_params[quota_ram] != 'default' {
    nova_config {
      'DEFAULT/quota_ram':      value => $nova_conf_additional_params[quota_ram];
    }
  }

  if $nova_conf_additional_params[quota_floating_ips] != 'default' {
    nova_config {
      'DEFAULT/quota_floating_ips':      value => $nova_conf_additional_params[quota_floating_ips];
    }
  }

  if $nova_conf_additional_params[quota_fixed_ips] != 'default' {
    nova_config {
      'DEFAULT/quota_fixed_ips':      value => $nova_conf_additional_params[quota_fixed_ips];
    }
  }

  if $nova_conf_additional_params[quota_driver] != 'default' {
    nova_config {
      'DEFAULT/quota_driver':      value => $nova_conf_additional_params[quota_driver];
    }
  }
}
