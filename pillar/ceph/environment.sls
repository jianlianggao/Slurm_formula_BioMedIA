nodes:
{% for N in range(1,3) %}
  monal{{ "%02d" % N }}:
    roles:
      - ceph-osd
    devs:
      - mapper/systemvg-osd
{% endfor %}
