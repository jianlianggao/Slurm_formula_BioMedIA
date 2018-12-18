# State munge has to be included to allow dependency on munge package
include:
  - .munge
##  - .ubuntu-xenial
#  - .ssh
#  - .screen
#  - .cgroup  # the cgroup.sls does nothing, this line is therefore commented out. Need to check cgroup.sls if needed
{% if grains['host'] == pillar['slurm']['controller'] or grains['host'] == pillar['slurm']['backupcontroller'] %}
  - .slurmdbd
{% endif %}

# The SLURM scheduling system

/etc/slurm-llnl/slurm.conf:
  file.managed:
    - source: salt://slurm/files/etc/slurm-llnl/slurm.conf
    - template: jinja

/etc/slurm-llnl/cgroup.conf:
  file.managed:
    - source: salt://slurm/files/etc/slurm-llnl/cgroup.conf

/etc/slurm-llnl/slurm.cert:
  file.managed:
    - source: salt://slurm/files/etc/slurm-llnl/slurm.cert
    - mode: 400

# FIXME can the next 2 be factored?
/var/spool/slurm-llnl:
  file.directory:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

/var/spool/slurm-llnl/cgroup:
  file.directory:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

{% if grains['host'] != pillar['slurm']['controller'] or grains['host'] == pillar['slurm']['backupcontroller'] %}
/var/log/slurm-llnl/slurm.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm
{% endif %}

# specific to SLURM Controller
{% if grains['host'] == pillar['slurm']['controller'] or grains['host'] == pillar['slurm']['backupcontroller'] %}
/etc/slurm-llnl/slurm.key:
  file.managed:
    - source: salt://slurm/files/etc/slurm-llnl/slurm.key
    - mode: 400
 
## Unused because of slurmdbd
#/var/log/slurm-llnl/accounting.log:
#  file.managed:
#    - group: slurm
#    - user: slurm
#    - require:
#      - user: slurm
#
#/var/log/slurm-llnl/job_completions.log:
#  file.managed:
#    - group: slurm
#    - user: slurm
#    - require:
#      - user: slurm

/var/log/slurm-llnl/slurmctld.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

/var/log/slurm-llnl/sched.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm
{% endif %}


# TODO handle different names given distro (slurm, slurm-llnl, ...)
slurm:
  group.present:
    - system: True
    - gid: 97
  user.present:
    - fullname: SLURM daemon user account
    - uid: 14
    - gid_from_name: True
    - system: True
    - home: /var/spool/slurm-llnl
    - shell: /bin/true
{% if grains['host'] != pillar['slurm']['controller'] and grains['host'] != pillar['slurm']['backupcontroller'] %}
  pkg.installed:
    - sources:
      - libhdf5: salt://slurm_deb/libhdf5-100_1.10.0-patch1+docs-3_amd64.deb
      - libhwloc5: salt://slurm_deb/libhwloc5_1.11.5-1_amd64.deb
      - libpng16: salt://slurm_deb/libpng16-16_1.6.28-1_amd64.deb
      - libreadline7: salt://slurm_deb/libreadline7_7.0-0ubuntu2_amd64.deb
      - librrd8: salt://slurm_deb/librrd8_1.6.0-1_amd64.deb
      - slurm-wlm-basic-plugins: salt://slurm_deb/slurm-wlm-basic-plugins_16.05.9-1ubuntu1_amd64.deb
      - slurmd: salt://slurm_deb/slurmd_16.05.9-1ubuntu1_amd64.deb
      - slurm-client: salt://slurm_deb/slurm-client_16.05.9-1ubuntu1_amd64.deb
    - unless:
      - dpkg -l|grep slurmd
      - dpkg -l|grep slurm-wlm-basic-plugins
      - dpkg -l|grep slurm-client
{% endif %}
  service.running:
    - name: slurmd
    - watch:
      - user: slurm
      - pkg: slurmd
      - pkg: munge
      - file: /etc/slurm-llnl/slurm.conf
      - file: /var/spool/slurm-llnl
{% if grains['host'] == pillar['slurm']['controller'] or grains['host'] == pillar['slurm']['backupcontroller'] %}
      - file: /var/log/slurm-llnl/sched.log
      - file: /var/log/slurm-llnl/slurmctld.log
      - pkg: slurmdbd
{% endif %}

#slurm-plugins:  # install this pkg above, no need to have this separately.
#  pkg.installed:
#    - name: slurm-wlm-basic-plugins

/etc/slurm-llnl/gres.conf:
  file.managed:
{% if grains['host'] in [ "monal01", "monal02", "monal03" ] %}
    - source: salt://slurm/files/etc/slurm-llnl/{{ grains['host'] }}/gres.conf
{% else %} 
    - source: salt://slurm/files/etc/slurm-llnl/default/gres.conf
{% endif %}

