# vi: set ft=yaml.jinja :

{% import 'ceph/ceph/global_vars.jinja' as conf with context -%}

# do not use external repo
#include:
#  - .repo

include:
  - .ceph

ceph-common:
  pkg.installed

{% for mon in salt['mine.get']('roles:ceph-mon','grains.items','grain') -%}

cp.get_file {{ mon }}{{ conf.conf_file }}:
  module.wait:
    - name: cp.get_file
    - path: salt://{{ mon }}/files{{ conf.conf_file }}
    - dest: {{ conf.conf_file }}

{% endfor -%}

{{ conf.admin_keyring }}:
  file.managed:
    - source: salt://ceph/files{{ conf.admin_keyring }}
    - target: {{ conf.admin_keyring }}

