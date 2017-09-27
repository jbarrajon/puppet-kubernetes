#
class kubernetes::install inherits ::kubernetes {

  $archive_name = "kubernetes-${::kubernetes::release_type}-${::kubernetes::version}"
  $archive_url = "https://dl.k8s.io/v${::kubernetes::version}/kubernetes-${::kubernetes::release_type}-${::kubernetes::os_release}-${::kubernetes::release_arch}.tar.gz"

  archive { "${archive_name}.tar.gz":
    path            => "/tmp/${archive_name}.tar.gz",
    source          => $archive_url,
    checksum        => $::kubernetes::checksum,
    checksum_type   => $::kubernetes::checksum_type,
    checksum_verify => $::kubernetes::checksum_verify,
    extract         => true,
    extract_command => "tar -xzf /tmp/${archive_name}.tar.gz --one-top-level",
    extract_path    => $::kubernetes::archive_path,
    creates         => "${::kubernetes::archive_path}/${archive_name}",
    cleanup         => true,
  }

  $::kubernetes::binaries.each |String $binary| {
    file { "${::kubernetes::binaries_path}/${binary}":
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "${::kubernetes::archive_path}/${archive_name}/kubernetes/${::kubernetes::release_type}/bin/${binary}",
    }
  }

  if $::kubernetes::release_type != 'client' {
    file { '/etc/kubernetes':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  if $::kubernetes::install_cni_net {
    $cni_archive_name = "cni-plugins-${::kubernetes::release_arch}-v${::kubernetes::cni_version}"
    $cni_archive_url = "https://github.com/containernetworking/plugins/releases/download/v${::kubernetes::cni_version}/cni-plugins-${::kubernetes::release_arch}-v${::kubernetes::cni_version}.tgz"

    file { [
      '/opt/cni',
      '/opt/cni/bin',
      '/etc/cni',
      '/etc/cni/net.d',
    ]:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    archive { "${cni_archive_name}.tgz":
      path            => "/tmp/${cni_archive_name}.tgz",
      source          => $cni_archive_url,
      checksum_url    => "${cni_archive_url}.sha256",
      checksum_type   => 'sh256',
      checksum_verify => true,
      extract         => true,
      extract_path    => '/opt/cni/bin',
      creates         => '/opt/cni/bin/vlan',
      require         => File['/opt/cni/bin'],
      cleanup         => true,
    }
  }

}
