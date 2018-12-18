# vi: set ft=yaml.jinja :

# insert cephfs in autofs and make sure service is reloaded

{% import 'ceph/ceph/global_vars.jinja' as conf with context -%}

ceph-fs-common:
  pkg.installed: []

/etc/ceph/ceph.client.admin.secret:
  file.managed:
    - source: salt://ceph/files/{{ conf.cephfs_secret_key }}
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
    - contents: "fastmp             -fstype=ceph,name=admin,secretfile=/etc/ceph/ceph.client.admin.secret           {{ ','.join(salt['mine.get']('roles:ceph-mon','grains.items','grain').keys()) }}:/"

