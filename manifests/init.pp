#
class kubernetes (
  $archive_path             = $::kubernetes::params::archive_path,
  $binaries                 = $::kubernetes::params::binaries,
  $binaries_path            = $::kubernetes::params::binaries_path,
  $cni_configs              = $::kubernetes::params::cni_configs,
  $cni_config_defaults      = $::kubernetes::params::cni_config_defaults,
  $cni_version              = $::kubernetes::params::cni_version,
  $install_cni_net          = $::kubernetes::params::install_cni_net,
  $kubeconfigs              = $::kubernetes::params::kubeconfigs,
  $kubeconfig_defaults      = $::kubernetes::params::kubeconfig_defaults,
  $os_release               = $::kubernetes::params::os_release,
  $release_arch             = $::kubernetes::params::release_arch,
  $release_type             = $::kubernetes::params::release_type,
  $service_configs          = $::kubernetes::params::service_configs,
  $service_configs_defaults = $::kubernetes::params::service_configs_defaults,
  $services                 = $::kubernetes::params::services,
  $service_defaults         = $::kubernetes::params::service_defaults,
  $version                  = $::kubernetes::params::version,
) inherits ::kubernetes::params {

  validate_absolute_path($archive_path)
  validate_array($binaries)
  validate_absolute_path($binaries_path)

  validate_bool($install_cni_net)
  if $install_cni_net {
    validate_hash($cni_configs)
    validate_hash($cni_config_defaults)
    validate_string($cni_version)
  }

  validate_hash($kubeconfigs)
  validate_hash($kubeconfig_defaults)
  validate_string($os_release)
  validate_string($release_arch)

  if ! ($release_type in ['client', 'node', 'server']) {
    fail("\"${release_type}\" is not a valid \$release_type parameter value")
  }

  validate_hash($service_configs)
  validate_hash($service_configs_defaults)
  validate_hash($services)
  validate_hash($service_defaults)
  validate_string($version)

  include ::kubernetes::install
  include ::kubernetes::config
  include ::kubernetes::service

  Class['::kubernetes::install'] -> Class['::kubernetes::config']
  Class['::kubernetes::config'] -> Class['::kubernetes::service']

}
