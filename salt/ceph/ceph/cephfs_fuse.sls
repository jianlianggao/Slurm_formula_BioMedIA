# vi: set ft=yaml.jinja :

# insert cephfs in autofs and make sure service is reloaded

{% import 'ceph/ceph/global_vars.jinja' as conf with context -%}

ceph-fuse:
  pkg.installed: []

{{ conf.admin_keyring }}:
  file.managed:
    - source: salt://ceph/files{{ conf.admin_keyring }}
    - target: {{ conf.admin_keyring }}

/etc/ceph/ceph.conf:
  file.managed:
    - template: jinja
    - source: salt://ceph/files/{{ conf.conf_file }}
    - makedirs: true

autofs:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: /etc/auto.master
      - file: /etc/auto.ceph

/etc/auto.master-special:
  file.touch

/etc/auto.master:
  file.append:
    - text:
      - "/mnt    /etc/auto.ceph  --timeout 60"

/etc/auto.ceph:
  file.managed:
    - contents: "fastmp             -fstype=fuse.ceph,allow_other,rw           conf=/etc/ceph/ceph.conf"

