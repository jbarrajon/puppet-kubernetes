#
class kubernetes::service inherits ::kubernetes {

  $services = lookup('kubernetes::services', { 'value_type' => Hash, 'merge' => 'deep', 'default_value' => $::kubernetes::services })
  create_resources('service', $services, $::kubernetes::service_defaults)

}
