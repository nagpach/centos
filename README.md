# centos-docker images

## Overview

There are the following images available:

* latest (= systemd-latest)

## Further description of images

### All images

* `yum-priorities`-plugin is installed and enabled
* rpmforge-repository is installed and enabled
* `tar`-command is installed
* `vim`-editor is installed
* Workdir is "/"

### "systemd-"-images

To run a image please use this command:

docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro username/centos
