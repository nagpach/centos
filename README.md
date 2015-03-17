# centos-docker images

## Overview

There are the following images available:

* latest (= systemd-latest)
* docker-latest
* systemd-latest

## Further description of images

### All images

* `yum-priorities`-plugin is installed and enabled
* rpmforge-repository is installed and enabled
* `tar`-command is installed
* `vim`-editor is installed
* Workdir is "/"

### "systemd-"-images

All `systemd-`-images have `systemd` installed. They should be run with
`systemd-nspawn`.

### "docker-"-images

All `docker-`-images are compatible with `docker`.
