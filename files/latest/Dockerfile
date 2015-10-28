FROM centos:latest
MAINTAINER dev@fedux.org

ENV container docker

# Disable networking by default
ENV NETWORKING_ENABLED no

# ENV http_proxy http://172.17.42.1:3128
# ENV https_proxy https://172.17.42.1:3128

# No mirror plugin
RUN sed -ir -e "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf

# Update all repos
RUN yum update -y centos-release \
    && yum update -y

# Some helpful tools
RUN yum install -y vim tar passwd dhclient curl openssh-server

# Set priorities for default repositories
RUN yum install -y yum-priorities \
    && sed -i -e '/\[base\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i -e '/\[updates\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i -e '/\[extras\]/ a \priority=1' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i -e '/\[centosplus\]/ a \priority=2' /etc/yum.repos.d/CentOS-Base.repo

# Limit size of journal in containers
RUN sed -ir "s/#SystemMaxUse=.*/SystemMaxUse=50M/" /etc/systemd/journald.conf

# Make rpmforge work
ADD enable-rpmforge.sh /usr/local/bin/enable-rpmforge.sh
RUN chmod +x /usr/local/bin/enable-rpmforge.sh

# Make epel work
ADD enable-epel.sh /usr/local/bin/enable-epel.sh
RUN chmod +x /usr/local/bin/enable-epel.sh

# Setup gosu for easier command execution
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && rm -r /root/.gnupg/ \
    && chmod +x /usr/local/bin/gosu

# Make it possible to login via machinectl
# ADD container-getty@.service /usr/lib/systemd/system/container-getty@.service
#RUN systemctl enable container-getty@.service
# RUN systemctl enable getty.service

# Setup dbus
RUN yum install -y dbus \
  && sed -i -e "s/OOMScoreAdjust/# OOMScoreAdjust/" /usr/lib/systemd/system/dbus.service

# Set TERM to make shells look good
# if docker exec -it <container> bash
# is used
ADD profile.d-xterm.sh /etc/profile.d/xterm.sh
RUN chmod +x /etc/profile.d/xterm.sh

# No need to configure the network the network is setup by docker
RUN sed -i -e "\$aNETWORKING=${NETWORKING_ENABLED}" /etc/sysconfig/network

# Install debugging utils
RUN yum install -y net-tools telnet bind-utils

# Setup ssh
 RUN install -m 0755 -d /var/ssh/authorized_keys/ \
     && install -m 0755 -d /var/ssh/host_keys \
     && sed -i -e 's/^AuthorizedKeysFile.*/AuthorizedKeysFile	\/var\/ssh\/authorized_keys\/%u/' /etc/ssh/sshd_config \
     && sed -i -e 's/^#UseDNS.*/UseDNS	no/' /etc/ssh/sshd_config \
     && sed -i -e '/^HostKey/ s/etc\/ssh/var\/ssh\/host_keys/' /etc/ssh/sshd_config \
     && sed -i -e 's/etc\/ssh/var\/ssh\/host_keys/' /usr/lib/systemd/system/sshd-keygen.service \
     && sed -i -e 's/etc\/ssh/var\/ssh\/host_keys/' /usr/sbin/sshd-keygen \
     && sed -i -e 's/^PasswordAuthentication.*/PasswordAuthentication	no/' /etc/ssh/sshd_config \
     && systemctl disable sshd

VOLUME ["/var/ssh/"]

# No graphical login
RUN ln -sf /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target

# Cleanup
RUN rm -fr /tmp/* \
    && yum clean -y all

# Working Directory
WORKDIR /

# Make those available to run systemd as init daemon
VOLUME ["/sys/fs/cgroup", "/run", "/tmp", "/var/log/journal"]

# Run systemd
CMD ["/usr/sbin/init"]
