/etc/apt/preferences.d/java:
  file.managed:
    - source: salt://misc/files/etc/apt/preferences.d/java
    - makedirs: true

/etc/apt/sources.list.d/openjdk-r-ppa-xenial.list:
  file.managed:
    - source: salt://misc/files/etc/apt/sources.list.d/openjdk-r-ppa-xenial.list
    - makedirs: true

openjdk-7-jre:
  pkg.installed: []
openjdk-8-jre:
  pkg.installed: []

oracle-java7-jdk:
  pkg.purged: []
oracle-java8-jdk:
  pkg.purged: []
