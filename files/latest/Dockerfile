FROM centos:latest
MAINTAINER dev@fedux.org

ENV http_proxy http://172.17.42.1:3128
ENV https_proxy https://172.17.42.1:3128

# No mirror plugin
RUN sed -ir -e "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf

# Update all repos
RUN yum update -y centos-release
RUN yum update -y

# Some helpful tools
RUN yum install -y vim tar

# Make it possible to set password
RUN yum install -y passwd

# DHCP client
RUN yum install -y dhclient

# Set priorities for default repositories
RUN yum install -y yum-priorities
RUN sed -i -e '/\[base\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[updates\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[extras\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[centosplus\]/ a \priority=2' /etc/yum.repos.d/CentOS-Base.repo

# Make rpmforge work
RUN yum install -y curl
RUN rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
RUN sed -i -e '/\[rpmforge\]/ a \priority=3' /etc/yum.repos.d/rpmforge.repo
RUN yum update -y

# Make it possible to login via machinectl
ADD container-getty@.service /usr/lib/systemd/system/container-getty@.service

# No graphical login
RUN ln -fs /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target

# Add link for mtab
RUN ln -fs /proc/self/mounts /etc/mtab

# Cleanup
RUN rm -fr /tmp/*
RUN yum clean -y all

# Working Directory
WORKDIR /

# Make those available to run systemd as init daemon
VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]
ENV container docker

# Run systemd
CMD ["/usr/sbin/init"]
