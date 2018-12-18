# vi: set ft=yaml.jinja :

# FIXME fails for some some reason???!!!???
mon_setup:
  salt.state:
    - tgt: 'roles:ceph-mon'
    - tgt_type: grain
    - sls: ceph.ceph.mon
    - expect_minions: True

osd_setup:
  salt.state:
    - tgt: 'roles:ceph-osd'
    - tgt_type: grain
    - sls: ceph.ceph.osd
#    - require:
#      - salt: mon_setup
