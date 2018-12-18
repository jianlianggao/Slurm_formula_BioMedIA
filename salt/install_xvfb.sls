install_xvfb:
  pkg.installed:
    - sources:
      - x11-xkb-utils: salt://x11-xkb-utils_7.7+2_amd64.deb
    - unless:
      - dpkg -l|grep x11-xkb-utils
  cmd.run:
    - name: apt install -y xvfb
    - unless:
         - dpkg -l|grep xvfb
