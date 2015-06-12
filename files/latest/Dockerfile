FROM centos:latest
MAINTAINER dev@fedux.org

# ENV http_proxy http://172.17.42.1:3128
# ENV https_proxy https://172.17.42.1:3128

# No mirror plugin
RUN sed -ir -e "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf

# Update all repos
RUN yum update -y centos-release \
    && yum update -y

# Some helpful tools
# net-tools telnet
RUN yum install -y vim tar passwd dhclient curl openssh-server

# Set priorities for default repositories
RUN yum install -y yum-priorities \
    && sed -i -e '/\[base\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i -e '/\[updates\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i -e '/\[extras\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i -e '/\[centosplus\]/ a \priority=2' /etc/yum.repos.d/CentOS-Base.repo

# Make rpmforge work
RUN rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm \
    && sed -i -e '/\[rpmforge\]/ a \priority=3' /etc/yum.repos.d/rpmforge.repo

# Setup gosu for easier command execution
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

# Make it possible to login via machinectl
ADD container-getty@.service /usr/lib/systemd/system/container-getty@.service

# No need to configure the network the network is setup by docker
RUN sed -i -e 's/NETWORKING=.*$/NETWORKING=no/' /etc/sysconfig/network

# Setup ssh
RUN install -m 0755 -d /var/ssh/authorized_keys/ \
    && sed -i -e 's/^AuthorizedKeysFile.*/AuthorizedKeysFile	\/var\/ssh\/authorized_keys\/%u/' /etc/ssh/sshd_config \
    && sed -i -e 's/^PasswordAuthentication.*/PasswordAuthentication	no/' /etc/ssh/sshd_config

# No graphical login
RUN ln -sf /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target

# Cleanup
RUN rm -fr /tmp/* \
    && yum clean -y all

# Working Directory
WORKDIR /

# Make those available to run systemd as init daemon
VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]
ENV container docker

# Run systemd
CMD ["/usr/sbin/init"]
