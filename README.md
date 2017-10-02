# Puppet Kubernetes

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Requirements](#requirements)
4. [Usage](#usage)

## Overview

This module installs Kubernetes, the container orchestration tool.

## Module Description

What it does:
* Downloads client, node or server release archive from https://dl.k8s.io.
* After extraction, copies specific binaries to system path.
* Optionally downloads & installs CNI networking plugins.
* Manages kubeconfig files.
* Manages service configuration files.
* Manages CNI networking configuration files (only if CNI was installed).

What it does not (and will not) do:
* Manage Docker
* Manage Etcd

## Requirements

This module uses
[puppet-archive](https://github.com/voxpupoli/puppet-archive)
to download, verify and extract kubernetes release archives.

The [stdlib](https://github.com/puppetlabs/puppetlabs-stdlib) module is also used for parameter checking, but that is required by puppet-archive anyway.

## Usage

To actually use this module, you must provide the `binaries`, `os_release`, `release_arch`, `release_type` and `version` parameters.

Check the [Kubernetes Changelog](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG.md) and search for a release you want to install.

```puppet
class { 'kubernetes':
  binaries     => ['kubectl', 'kubelet', 'kube-proxy'],
  os_release   => 'linux',
  release_arch => 'amd64',
  release_type => 'node',
  version      => '1.7.6',
}
```
NOTE: verify that values in `binaries` match binaries in the `release_type` archive, or the puppet run will crash; eg. kube-apiserver is in server releases, but not in node releases.

Check the examples directory for specific use cases.
