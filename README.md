# centos-docker images

## Overview

There are the following images available:

* latest

## Further description of images

### All images

* `yum-priorities`-plugin is installed and enabled
* rpmforge-repository is installed and enabled
* `tar`-command is installed
* `vim`-editor is installed
* Workdir is "/"

### "systemd-"-images

To run a image please use this command:

```bash
docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v $PWD/ssh/:/var/ssh -v /var/log/journal:/var/log/journal -p 8022:22 username/centos
```

*Example:*

```docker
FROM feduxorg/centos:latest
MAINTAINER fedux.org

ADD id_rsa.pub /var/ssh/authorized_keys/root

# Otherwise a new ssh host key will be generated on each start
RUN /usr/sbin/sshd-keygen
```

```bash
docker build -t username/centos-xyz .
```
