include:
  - .java
  - .python
  - .sqlite3
  - .blas
{% if grains['host'] != pillar['slurm']['controller'] %}
  - .cgal
{% endif %}

