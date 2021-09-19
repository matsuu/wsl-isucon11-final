#!/bin/bash

set -ex

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends ansible curl git

GITDIR="/tmp/isucon11-final"
rm -rf ${GITDIR}
git clone --depth=1 https://github.com/isucon/isucon11-final.git ${GITDIR}
(
  cd ${GITDIR}/provisioning/ansible

  # common
  mkdir -p /dev/shm/files-generated
  git rev-parse HEAD > /dev/shm/files-generated/REVISION
  sed -i -e '/name.*Unarchive/,/dest/d' -e '/name.*Create \/tmp\/isucon11-final/,/^$/s/^$/    recurse: yes/' roles/common/tasks/main.yml

  # bench
  sed -i -e '/InsecureSkipVerify/s/=.*/= true/' ../../benchmarker/main.go
  sed -i -e '/name.*Deploy.*benchmarker"/i - become_user: isucon\n  args:\n    chdir: /tmp/isucon11-final/benchmarker\n  environment:\n    PATH: "/home/isucon/local/go/bin:{{ ansible_env.PATH }}"\n  shell: make\n' -e 's@/dev/shm/files-generated@/tmp/isucon11-final/benchmarker/bin@' roles/bench/tasks/bench.yml

  # contestant
  openssl x509 -in <(openssl req -subj '/CN=*.t.isucon.dev' -nodes -newkey rsa:2048 -keyout roles/contestant/files/etc/nginx/certificates/tls-key.pem) -req -signkey roles/contestant/files/etc/nginx/certificates/tls-key.pem -sha256 -days 3650 -out roles/contestant/files/etc/nginx/certificates/tls-cert.pem -extfile <(echo -e "basicConstraints=critical,CA:true,pathlen:0\nsubjectAltName=DNS.1:*.t.isucon.dev")
  ansible-playbook -i standalone.hosts --connection=local site.yml
)
rm -rf ${GITDIR}

apt-get remove -y --purge ansible
apt-get autoremove -y
#
