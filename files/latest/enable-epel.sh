#!/bin/sh

set -e

yum -y install epel-release
sed -i -e '/\[epel.*\]/ a \priority=3' /etc/yum.repos.d/epel.repo

