class quickstack::neutron::plugins::neutron_config (
  $neutron_conf_additional_params= { default_quota              => 'default',
                                     quota_network              => 'default',
                                     quota_subnet               => 'default',
                                     quota_port                 => 'default',
                                     quota_security_group       => 'default',
                                     quota_security_group_rule  => 'default',
                                     network_auto_schedule      => 'default',
                                   },
) {
  # Additional parameters in neutron.conf and nova.conf
  if $neutron_conf_additional_params[default_quota] != 'default' {
    neutron_config {
      'quotas/default_quota':          value => $neutron_conf_additional_params[default_quota];
    }
  }

  if $neutron_conf_additional_params[quota_network] != 'default' {
    neutron_config {
      'quotas/quota_network':          value => $neutron_conf_additional_params[quota_network];
    }
  }

  if $neutron_conf_additional_params[quota_subnet] != 'default' {
    neutron_config {
      'quotas/quota_subnet':          value => $neutron_conf_additional_params[quota_subnet];
    }
  }

  if $neutron_conf_additional_params[quota_port] != 'default' {
    neutron_config {
      'quotas/quota_port':          value => $neutron_conf_additional_params[quota_port];
    }
  }

  if $neutron_conf_additional_params[quota_security_group] != 'default' {
    neutron_config {
      'quotas/quota_security_group':          value => $neutron_conf_additional_params[quota_security_group];
    }
  }

  if $neutron_conf_additional_params[quota_security_group_rule] != 'default' {
    neutron_config {
      'quotas/quota_security_group_rule':      value => $neutron_conf_additional_params[quota_security_group_rule];
    }
  }

  if $neutron_conf_additional_params[network_auto_schedule] != 'default' {
    neutron_config {
      'DEFAULT/network_auto_schedule':      value => $neutron_conf_additional_params[network_auto_schedule];
    }
  }

}
