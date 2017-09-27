#
class kubernetes::config inherits ::kubernetes {

  $kubeconfigs = lookup('kubernetes::kubeconfigs', { 'value_type' => Hash, 'merge' => 'deep', 'default_value' => $::kubernetes::kubeconfigs })
  create_resources('kubernetes::config::template', $kubeconfigs, $::kubernetes::params::kubeconfig_defaults)

  $service_configs = lookup('kubernetes::service_configs', { 'value_type' => Hash, 'merge' => 'deep', 'default_value' => $::kubernetes::service_configs })
  create_resources('kubernetes::config::template', $service_configs, $::kubernetes::params::service_configs_defaults)

  if $::kubernetes::install_cni_net {
    $cni_configs = lookup('kubernetes::cni_configs', { 'value_type' => Hash, 'merge' => 'deep', 'default_value' => $::kubernetes::cni_configs })
    create_resources('kubernetes::config::template', $cni_configs, $::kubernetes::params::cni_config_defaults)
  }

}
