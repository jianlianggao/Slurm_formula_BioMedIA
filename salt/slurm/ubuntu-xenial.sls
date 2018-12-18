# Ubuntu Xenial required for Slurm 2.9

/etc/apt/preferences.d/disable-xenial-policy:
  file.managed:
    - source: salt://slurm/files/etc/apt/preferences.d/disable-xenial-policy
    - mode: 644

/etc/apt/preferences.d/slurm-xenial-policy:
  file.managed:
    - source: salt://slurm/files/etc/apt/preferences.d/slurm-xenial-policy
    - mode: 644

/etc/apt/sources.list.d/xenial.list:
  file.managed:
    - source: salt://slurm/files/etc/apt/sources.list.d/xenial.list
    - mode: 644

