#!/bin/bash

# backup [optional]
for pg in `ls -ldh /var/lib/ceph/osd/ceph-1/current/*_head | tr -s ' ' | grep -v 'root root 0' | sed -e 's/.*current\/\(.\+\?\..*\)_head$/\1/' | head -n5`; do cp -r  /var/lib/ceph/osd/ceph-1/current/${pg}_head /data; done

# deletion
for pg in `ls -ldh /var/lib/ceph/osd/ceph-1/current/*_head | tr -s ' ' | grep -v 'root root 0' | sed -e 's/.*current\/\(.\+\?\..*\)_head$/\1/' | head -n5`; do find /var/lib/ceph/osd/ceph-1 -maxdepth 2 -name "${pg}_head" -exec rm -rf {} \;; done
