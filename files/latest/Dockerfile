FROM centos:latest
MAINTAINER dev@fedux.org

# Make systemd aware about the fact that it runs inside a container
ENV container docker

# No mirror plugin
RUN sed -ir -e "s/enabled=1/enabled=0/" /etc/yum/pluginconf.d/fastestmirror.conf

# Update all repos
RUN yum update -y centos-release \
    && yum update -y

# Some helpful tools
RUN yum install -y vim tar dhclient curl \
    # Install debugging utils
    && yum install -y net-tools telnet bind-utils strace lsof less

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

# Setup dbus
RUN yum install -y dbus \
  && sed -i -e "s/OOMScoreAdjust/# OOMScoreAdjust/" /usr/lib/systemd/system/dbus.service

# Set TERM to make shells look good if docker exec -it <container> bash is used
ADD profile.d-xterm.sh /etc/profile.d/xterm.sh
RUN chmod +x /etc/profile.d/xterm.sh

# No need to configure the network the network is setup by docker
RUN rm /usr/lib/systemd/system/systemd-remount-fs.service \
  && systemctl disable network

# No graphical login
RUN ln -sf /usr/lib/systemd/system/multi-user.target /etc/systemd/system/default.target

# Add script runner
ADD script-runner.service /etc/systemd/system/script-runner.service
ADD script-runner.sh /usr/local/bin/script-runner.sh
RUN systemctl enable script-runner \
  && chmod +x /usr/local/bin/script-runner.sh

# Cleanup
RUN rm -fr /tmp/* \
    && yum clean -y all

# Working Directory
WORKDIR /

# Export those available to run systemd as init daemon
VOLUME ["/sys/fs/cgroup", "/run", "/tmp"]

# Run systemd
CMD ["/usr/sbin/init"]

# To shutdown systemd in your container we need to use SIGINT
STOPSIGNAL "RTMIN+3"
