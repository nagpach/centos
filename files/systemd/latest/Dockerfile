FROM centos:latest
MAINTAINER fedux.org

# ENV http_proxy http://172.17.42.1:3128
# ENV https_proxy https://172.17.42.1:3128

# No mirror plugin
RUN sed -ir -e "s/enabled=1/enabled=0/" etc/yum/pluginconf.d/fastestmirror.conf

# Update all repos
RUN yum update -y

# Better editor for troubleshooting
RUN yum install -y vim

# Give systemd a try
RUN yum remove -y fakesystemd
RUN yum install -y systemd dhclient

# Set priorities for default repositories
RUN yum install -y yum-priorities
RUN sed -i -e '/\[base\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[updates\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[extras\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo
RUN sed -i -e '/\[centosplus\]/ a \priority=2' /etc/yum.repos.d/CentOS-Base.repo

# Make rpmforge work
RUN yum install -y curl
RUN curl -o /tmp/rpmforge.rpm -L http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
RUN rpm -Uvh /tmp/rpmforge.rpm
RUN sed -i -e '/\[rpmforge\]/ a \priority=3' /etc/yum.repos.d/rpmforge.repo
RUN yum update -y

# Install tar
RUN yum install -y tar bash

# Cleanup
RUN rm -r /tmp/*
RUN yum clean -y all

# Working Directory
WORKDIR /

# Shell as fall back
CMD ["/bin/bash"]
