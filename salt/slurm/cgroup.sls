# Munge provides authentication for SLURM

# munge.key must be the same across all the nodes of the cluster

/etc/default/grub:
  file.managed:
    - source: salt://slurm/files/etc/default/grub
    - mode: 400

/etc/default/grub-special:
  file.touch

