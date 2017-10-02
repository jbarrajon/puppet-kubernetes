# Puppet Kubernetes - Configuration Examples

## Basics

The `kubernetes` class has the following parameters that are used to manage configuration files:
* `kubeconfigs`: kubernetes configuration files for use with kubectl, kubelet, kube-proxy, etc.
* `service_configs`: service configuration files eg. systemd units, init scripts...
* `cni_configs`: cni network configuration files

Config files are managed by the defined type `kubernetes::config::template`, so the parameters must match it's definition.

Services can be managed the same way using the `services` parameter, and are created as a `service` resource directly by the `kubernetes::service` class.

The class `kubernetes::config` uses the defined type `kubernetes::config::template` as a wrapper to create file resources.

Each hash object can have these parameters:
* template: the puppet template used to render the resource.
* options: will be within scope of the template, so can be anything, really.
* path: where the file resource will be rendered.

Defaults for `template` and `path` of each config are set in the `kubernetes::params` class, but can be overridden in the main class.
