base:
  '*':
#    - salt    # don't need this because all salt-minion and master have been setup manually
#    - munin
#    - misc
  # apply salt formula to all minions but biomedia02
#  '^(?!biomedia02).*':
#    - match: pcre
    - slurm
#  # ceph only concerns rocs machines
#  'roc*':
#    - ceph
