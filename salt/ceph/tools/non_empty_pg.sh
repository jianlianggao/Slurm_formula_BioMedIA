#!/bin/bash

for pg in `ls -ldh /var/lib/ceph/osd/ceph-1/current/*_head | tr -s ' ' | grep -v 'root root 0' | sed -e 's/.*current\/\(.\+\?\..*\)_head$/\1/'`; do ceph pg map ${pg}; done

