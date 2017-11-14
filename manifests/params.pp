#
class kubernetes::params {

  $archive_path  = '/opt'
  $binaries      = ['kubectl', 'kubefed', 'kubelet', 'kube-proxy'] # ['kube-apiserver', 'kube-controller-manager', 'kube-scheduler']
  $binaries_path = '/usr/bin'
  $cni_configs         = {}
  $cni_config_defaults = {
    'path' => '/etc/cni/net.d',
    'template' => 'kubernetes/json.erb',
  }
  $cni_version     = '0.6.0'
  $install_cni_net = false
  $kubeconfigs         = {}
  $kubeconfig_defaults = {
    'path'     => '/etc/kubernetes',
    'template' => 'kubernetes/kubeconfig.erb',
  }
  $os_release   = 'linux'
  $release_arch = 'amd64'
  $release_type = 'node'
  $service_configs          = {}
  $service_configs_defaults = {
    'path'     => '/etc/systemd/system',
    'template' => 'kubernetes/systemd.erb',
    'notify'   => Exec['systemd_reload_kubernetes'],
  }
  $services         = {}
  $service_defaults = {
    'ensure'  => 'running',
    'enable'  => true,
    'require' => Exec['systemd_reload_kubernetes'],
  }
  $version = undef

}
