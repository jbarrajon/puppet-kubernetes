#
class kubernetes (
  $archive_path    = $::kubernetes::params::archive_path,
  $binaries        = $::kubernetes::params::binaries,
  $binaries_path   = $::kubernetes::params::binaries_path,
  $checksum        = $::kubernetes::params::checksum,
  $checksum_type   = $::kubernetes::params::checksum_type,
  $cni_configs     = $::kubernetes::params::cni_configs,
  $cni_version     = $::kubernetes::params::cni_version,
  $install_cni_net = $::kubernetes::params::install_cni_net,
  $kubeconfigs     = $::kubernetes::params::kubeconfigs,
  $os_release      = $::kubernetes::params::os_release,
  $release_arch    = $::kubernetes::params::release_arch,
  $release_type    = $::kubernetes::params::release_type,
  $service_configs = $::kubernetes::params::service_configs,
  $services        = $::kubernetes::params::services,
  $version         = $::kubernetes::params::version,
) inherits ::kubernetes::params {

  validate_absolute_path($archive_path)
  validate_array($binaries)
  validate_absolute_path($binaries_path)

  $checksum_verify = $checksum ? {
    undef   => false,
    ''      => false,
    default => true,
  }

  if $checksum_verify {
    if ! ($checksum_type in ['md5', 'sha1', 'sha2', 'sh256', 'sha384', 'sha512']) {
      fail("\"${checksum_type}\" is not a valid \$checksum_type parameter value")
    }
  }

  validate_bool($install_cni_net)
  if $install_cni_net {
    validate_hash($cni_configs)
    validate_string($cni_version)
  }

  validate_hash($kubeconfigs)
  validate_string($os_release)
  validate_string($release_arch)

  if ! ($release_type in ['client', 'node', 'server']) {
    fail("\"${release_type}\" is not a valid \$release_type parameter value")
  }

  validate_hash($service_configs)
  validate_hash($services)
  validate_string($version)

  include ::kubernetes::install
  include ::kubernetes::config
  include ::kubernetes::service

  Class['::kubernetes::install'] -> Class['::kubernetes::config']
  Class['::kubernetes::config'] -> Class['::kubernetes::service']

}
