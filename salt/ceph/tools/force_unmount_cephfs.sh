#!/bin/bash

umount -lf /mnt/fastmp &
umount -lf /mnt/fastmp &
sleep 1
killall -9 umount
service autofs restart

umount -lf /mnt/fastmp &
umount -lf /mnt/fastmp &
sleep 1
killall -9 umount
service autofs restart

