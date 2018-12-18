/etc/apt/sources.list.d/xenial.list:
  cmd.run:
    - name: rm /etc/apt/sources.list.d/xenial.list
/etc/apt/sources.list.d/utopic.list:
  cmd.run:
    - name: rm /etc/apt/sources.list.d/utopic.list
update list:
  cmd.run:
    - name: apt-get update
