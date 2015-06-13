#!/bin/sh

set -e

yum install epel-release
sed -i -e '/\[epel.*\]/ a \priority=3' /etc/yum.repos.d/rpmforge.repo
