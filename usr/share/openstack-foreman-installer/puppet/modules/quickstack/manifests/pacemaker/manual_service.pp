define quickstack::pacemaker::manual_service (
  $start      = false,
  $stop       = false,
) {
  if str2bool_i("$stop") {
    exec {"one-time-${name}-disable":
      command      => "/sbin/chkconfig ${name} off",
    }
  }
  if str2bool_i("$start") {
    exec {"one-time-${name}-start":
      command      => "/sbin/service ${name} start",
    }
  }
}
