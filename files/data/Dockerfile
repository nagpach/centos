FROM feduxorg/centos
MAINTAINER dev@fedux.org

# ENV http_proxy http://172.17.42.1:3128
# ENV https_proxy https://172.17.42.1:3128

RUN mkdir -p /var/ssh \
    && chown -R root:root /var/ssh

USER root

VOLUME ["/var/ssh"]
