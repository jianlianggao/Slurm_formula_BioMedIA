# vi: set ft=yaml.jinja :

{% import 'ceph/ceph/global_vars.jinja' as conf with context -%}
{% set psls = sls.split('.')[0] -%}

# do not use external repo
#include:
#  - .repo

ceph:
  pkg.installed

{{ conf.conf_file }}:
  file.managed:
    - template: jinja
    - source: salt://ceph/files/etc/ceph/ceph.conf
    - user: root
    - group: root
    - mode: '0644'
    - require:
      - pkg: ceph

cp.push {{ conf.conf_file }}:
  module.wait:
    - name: cp.push
    - path: {{ conf.conf_file }}
    - watch:
      - file: {{ conf.conf_file }}
