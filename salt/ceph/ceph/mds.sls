# vi: set ft=yaml.jinja :

{% import 'ceph/ceph/global_vars.jinja' as conf with context -%}

{% set ip = salt['network.ip_addrs'](conf.mon_interface)[0] -%}
{% set secret = '/var/lib/ceph/tmp/' + conf.cluster + '.mds.keyring' -%}
{% set mdsmap = '/var/lib/ceph/tmp/' + conf.cluster + 'mdsmap' -%}

include:
  - .ceph

ceph-mds:
  pkg.installed: []

get_mds_map:
  cmd.run:
    - name: ceph --cluster {{ conf.cluster }} mds getmap -o {{ mdsmap }}
    - onlyif: test -f {{ conf.admin_keyring }}
    - unless: test -f {{ mdsmap }}

/var/lib/ceph/mds/{{ conf.cluster }}-{{ conf.host }}:
  file.directory: []

gen_admin_keyring:
  cmd.run:
    - name: |
        ceph auth get-or-create mds.{{ conf.host }} \
                       mon 'allow rwx' \
                       osd 'allow *' \
                       mds 'allow *' \
                       -o /var/lib/ceph/mds/{{ conf.cluster }}-{{ conf.host }}/keyring
    - unless: test -f /var/lib/ceph/mds/{{ conf.cluster }}-{{ conf.host }}/keyring

start_mds:
  cmd.run:
    - name: start ceph-mds id={{ conf.host }} cluster={{ conf.cluster }}
    - unless: status ceph-mds id={{ conf.host }} cluster={{ conf.cluster }}

/var/lib/ceph/mds/{{ conf.cluster }}-{{ conf.host }}/upstart:
  file.touch: []
