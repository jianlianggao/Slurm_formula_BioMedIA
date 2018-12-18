
slurm:
  controller: biomedia03
  backupcontroller: biomedia10
  nodes:
    batch:
      gpus:
        monal01:
          mem: 200000
          cores: 40
          gres:
            gpu: 8
        monal02:
          mem: 200000
          cores: 40
          gres:
            gpu: 8
        monal03:
          mem: 200000
          cores: 56
          gres:
            gpu: 4

      cpus:
      {% for N in (1,2,5) %}
        biomedia0{{N}}:
          mem: 60000
          cores: 24
      {% endfor %}
        biomedia10:
          mem: 118000
          cores: 24
      {% for N in range(6,11) %}
        biomedia0{{N}}:
          mem: 118000
          cores: 64
      {% endfor %}
      {% for N in range(4,17) %}
        roc{{ "%02d" % N }}:
          mem: 243000
          cores: 32
      {% endfor %}


    interactive:
      cpus:
        biomedia11:
          mem: 252000
          cores: 32
        {% for N in range(1,4) %}
        roc{{ "%02d" % N }}:
          mem: 243000
          cores: 32
        {% endfor %}


  gres:
    - gpu

  db:
    name: slurmdb
    user: slurm
    password: 1BUy4eVv7X

