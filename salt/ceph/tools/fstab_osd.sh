#!/bin/bash

osd_number=`ceph osd tree | grep \`hostname -s\` -A1 | tail -n 1 | sed -e 's/.*osd\.\([0-9]\+\).*/\1/'`

echo -e "LABEL=osd\t/var/lib/ceph/osd/ceph-${osd_number}\tauto\tdefaults\t0 2"
