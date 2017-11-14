#
class kubernetes::service inherits ::kubernetes {

  exec { 'systemd_reload_kubernetes':
    user        => 'root',
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }

  $services = lookup('kubernetes::services', { 'value_type' => Hash, 'merge' => 'deep', 'default_value' => $::kubernetes::services })
  create_resources('service', $services, $::kubernetes::service_defaults)

}
