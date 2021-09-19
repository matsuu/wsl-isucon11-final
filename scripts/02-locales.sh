#!/bin/sh

set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y tzdata locales-all
localectl set-locale LANG=ja_JP.UTF-8
#
