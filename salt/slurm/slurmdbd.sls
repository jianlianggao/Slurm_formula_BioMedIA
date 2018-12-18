
# The SLURM scheduling system accounting database plugin

# specific to SLURM Controller
#{% if grains['host'] == pillar['slurm']['controller'] %}  #there is a condition statement before running this script, there is no need to have another statement here
/etc/slurm-llnl/slurmdbd.conf:
  file.managed:
    - source: salt://slurm/files/etc/slurm-llnl/slurmdbd.conf
    - template: jinja

/var/log/slurm-llnl/slurmdbd.log:
  file.managed:
    - group: slurm
    - user: slurm
    - require:
      - user: slurm

# TODO handle different names given distro (slurm, slurm-llnl, ...)
mysql server:
   pkg.installed:
     - pkgs:
        - mysql-server
     - unless:
        - dpkg -l |grep mysql-server
copy slurmdb:
   file.managed:
     - name: /tmp/slurmdb.sql
     - source: salt://slurmdb_backup_19jun2018.sql
     - unless:
        - ls /tmp/slurmdb.sql

import slurmdb:
   cmd.run:
     - name: mysql -u root -e "create database slurmdb" && mysql -u root slurmdb < /tmp/slurmdb.sql


#slurmdbd:
#  pkg.installed:
#    - pkgs:
#      - slurmdbd
#      - mysql-server
#  service.running:
#    - name: slurmdbd
#    - watch:
#      - file: /etc/slurm-llnl/slurmdbd.conf
## use local installation instead

slurmdbd:
  pkg.installed:
    - sources:
      - libhdf5: salt://slurm_deb/libhdf5-100_1.10.0-patch1+docs-3_amd64.deb
      - libhwloc5: salt://slurm_deb/libhwloc5_1.11.5-1_amd64.deb
      - libpng16: salt://slurm_deb/libpng16-16_1.6.28-1_amd64.deb
      - libreadline7: salt://slurm_deb/libreadline7_7.0-0ubuntu2_amd64.deb
      - librrd8: salt://slurm_deb/librrd8_1.6.0-1_amd64.deb
      - slurm-wlm-basic-plugins: salt://slurm_deb/slurm-wlm-basic-plugins_16.05.9-1ubuntu1_amd64.deb
      - slurmdbd: salt://slurm_deb/slurmdbd_16.05.9-1ubuntu1_amd64.deb
      - slurmctld: salt://slurm_deb/slurmctld_16.05.9-1ubuntu1_amd64.deb
      - slurm-client: salt://slurm_deb/slurm-client_16.05.9-1ubuntu1_amd64.deb
    - unless:
      - dpkg -l|grep slurmdbd
      - dpkg -l|grep slurmctld
#    - pkgs:
     # - slurm-llnl-slurmdbd   #-- moved to source installation
 #     - mysql-server
  service.running:
    - name: slurmdbd
    - watch:
      - file: /etc/slurm-llnl/slurmdbd.conf


#{% endif %}

