# vi: set ft=yaml.jinja :

{% import 'ceph/ceph/global_vars.jinja' as conf with context -%}

include:
  - .client
  - ceph.common.btrfs-tools

{{ conf.bootstrap_osd_keyring }}:
  file.managed:
    - source: salt://ceph/files/{{ conf.bootstrap_osd_keyring }}
    - makedirs: True

{% for dev in salt['pillar.get']('nodes:' + conf.host + ':devs') -%}
{% if dev -%}

# FIXME underlying filesystem should be a parameter

create_lv {{ dev }}:
  cmd.run:
    - name: lvcreate -l 100%FREE -n osd systemvg
    - unless: lvdisplay systemvg/osd   

format {{ dev }}:
  cmd.run:
    - name: mkfs.btrfs -L osd /dev/{{ dev }}
    - unless: parted --script /dev/{{ dev }} print | grep 'btrfs'

/etc/fstab-special:
  file.touch

disk_prepare_activate {{ dev }}:
  cmd.run:
    - name: 'OSDID=`ceph osd create`; mkdir -p /var/lib/ceph/osd/{{ conf.cluster }}-$OSDID; echo -e "LABEL=osd\t/var/lib/ceph/osd/{{ conf.cluster }}-$OSDID\tauto\tdefaults\t0 2" >> /etc/fstab; mount -L osd /var/lib/ceph/osd/{{ conf.cluster }}-$OSDID; ceph-osd -i $OSDID --mkfs --mkkey; ceph-disk-activate --mark-init upstart --mount /var/lib/ceph/osd/{{ conf.cluster }}-$OSDID'
    - unless: grep osd /proc/mounts

{% endif -%}
{% endfor -%}

start ceph-osd-all:
  cmd.run:
    - onlyif: initctl list | grep "ceph-osd-all stop/waiting"
