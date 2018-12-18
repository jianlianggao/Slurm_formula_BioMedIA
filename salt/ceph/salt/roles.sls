# vi: set ft=yaml.jinja :

include:
  - salt

/etc/salt/grains:
  file.managed:
    - template: jinja
    - source: salt://ceph/files/etc/salt/grains
    - require:
      - pkg: salt-minion
