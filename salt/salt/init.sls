
{% if grains['host'] == pillar['salt']['master'] %}

salt-master:
  pkg:
    - installed
  service:
    - running
    - require:
      - file: /etc/salt/master
    - watch:
      - pkg: salt-master
      - file: /etc/salt/master

/etc/salt/master:
  file.managed:
    - template: jinja
    - source: salt://salt/files/etc/salt/master

{% else %}

salt-minion:
  pkg:
    - installed
  service:
    - running
    - require:
      - file: /etc/salt/minion
    - watch:
      - pkg: salt-minion
      - file: /etc/salt/minion

/etc/salt/minion:
  file.managed:
    - template: jinja
    - source: salt://salt/files/etc/salt/minion

{% endif %}

