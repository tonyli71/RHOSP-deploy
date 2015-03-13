class quickstack::compute::qemu {
  file { "/usr/bin/qemu-system-x86_64":
   ensure => link,
   target => "/usr/libexec/qemu-kvm",
   notify => Service["nova-compute"],
  }

  nova_config{
    "DEFAULT/libvirt_cpu_mode": value => "none";
  }
}