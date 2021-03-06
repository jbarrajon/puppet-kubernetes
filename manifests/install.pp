#
class kubernetes::install inherits ::kubernetes {

  $archive_name = "kubernetes-${::kubernetes::release_type}-${::kubernetes::version}"
  $archive_url = "https://dl.k8s.io/v${::kubernetes::version}/kubernetes-${::kubernetes::release_type}-${::kubernetes::os_release}-${::kubernetes::release_arch}.tar.gz"

  file { "${::kubernetes::archive_path}/${archive_name}":
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  archive { "${archive_name}.tar.gz":
    path            => "/tmp/${archive_name}.tar.gz",
    source          => $archive_url,
    checksum_url    => "${archive_url}.sha1",
    checksum_type   => 'sha1',
    checksum_verify => true,
    extract         => true,
    extract_path    => "${::kubernetes::archive_path}/${archive_name}",
    creates         => "${::kubernetes::archive_path}/${archive_name}/kubernetes",
    cleanup         => true,
    require         => File["${::kubernetes::archive_path}/${archive_name}"],
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
      "/opt/${cni_archive_name}",
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
      checksum_type   => 'sha256',
      checksum_verify => true,
      extract         => true,
      extract_path    => "/opt/${cni_archive_name}",
      creates         => "/opt/${cni_archive_name}/vlan",
      require         => File["/opt/${cni_archive_name}"],
      cleanup         => true,
    }

    file { '/opt/cni/bin':
      ensure       => 'directory',
      owner        => 'root',
      group        => 'root',
      mode         => '0755',
      source       => "/opt/${cni_archive_name}",
      purge        => true,
      recurse      => true,
      recurselimit => 1,
    }
  }

}
