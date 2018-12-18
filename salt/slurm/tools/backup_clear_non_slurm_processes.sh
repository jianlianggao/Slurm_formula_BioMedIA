#!/bin/bash

SLURM_ALLOWED=`sshare -all -h -p | cut -d '|' -f2 | tail -n +3 | paste -s -d ','`
SLURM_USERS=`squeue -o %u | sort -u | head -n -1`
SLURM_NODES=`salt-key -L | tail -n +3 | head -n -2 | grep -v predict5`

# filter out actual users
SLURM_POTENTIAL_LEECHERS=${SLURM_ALLOWED}
for user in ${SLURM_USERS}; do 
	SLURM_POTENTIAL_LEECHERS=`echo ${SLURM_POTENTIAL_LEECHERS} | sed -re "s/${user}//g ; s/,,/,/g"`
done



for node in ${SLURM_NODES}; do
  ssh -oStrictHostKeyChecking=no ${node} ps -f -u ${SLURM_USERS} 
