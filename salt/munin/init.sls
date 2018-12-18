# Install munin-node on each node of the cluster (controller included)
munin-node:
  pkg:
    - installed
  service.running:
    - watch:
      - file: /etc/munin/plugins/*

# specify IP of Munin master (biomedia02) 
# and force host name to match master's definition
# TODO add biomedia02 to set of Salt-managed machines
/etc/munin/munin-node.conf:
  file.append:
    - text: [ "cidr_allow 146.169.2.149/24", "host_name {{ grains['host'] }}" ]

# disable undesired Munin plugins (remove link from node config dir)
{% for plugin in pillar['munin']['plugins']['disabled'] %}
clean_munin_plugin_{{ plugin }}:
  file.absent: 
    - name: /etc/munin/plugins/{{ plugin }}
{% endfor %}

