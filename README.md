# centos image

This "docker" image is based on the "Docker" CentOS base image.

## Differences between "feduxorg/centos" and "library/centos"

* Uses "systemd" as PID 1 by default
* Has the network service "disabled" - this really only prevents an error,
  but does not disable network functionality
* The fast mirror plugin is diabled to reduce round-trips before download
  packages via HTTP proxies
* Enabled priorities for CentOS repositories
* Limited journal size in container since an "outer" journald does not touch
  journals from other inner journalds.
* Added scripts to enable "EPEL" or "RPMFORGE"
* Added "gosu" as sudo/su replacement
* Enabled and running "dbus"-service
* Set TERM-environment variable to xterm
* Script Runner for simple initializer shell scripts
* Additional packages
  * vim
  * tar
  * dhclient
  * curl
  * net-tools
  * telnet
  * bind-utils
  * strace
  * lsof
* Addiontional volumes
  * /sys/fs/cgroup
  * /run
  * /tmp
* Default command is "/usr/sbin/init" aka "systemd"
* Workdir is "/"

## Usage

### Default

To run a image please use this command:

~~~bash
docker run -ti -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /var/log/journal:/var/log/journal feduxorg/centos
~~~

### Mount scripts

If a directory is mounted to `/var/lib/scripts`, the `script-runner.service`
starts `/usr/local/bin/script-runner.sh`. This script runs all executable files
in `/var/lib/scripts`.

~~~bash
docker run -it --rm --name centos1 -v /sys/fs/cgroup:/sys/fs/cgroup -v $(pwd)/tmp:/var/lib/scripts feduxorg/centos
~~~

### Login Prompt

If you prefer to have a login prompt you need to add the following in your
`Dockerfile`.

~~~docker
RUN systemctl unmask console-getty.service \
  && systemctl enable console-getty.service
~~~
