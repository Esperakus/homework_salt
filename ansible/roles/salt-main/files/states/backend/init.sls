/lib/systemd/system/go_web.service:
  file.managed:
    - source: salt://backend/go_web.service
    - user: root
    - group: root
    - mode: '0644'
    
/usr/bin/web-server:
  file.managed:
    - source: salt://backend/web-server
    - user: root
    - group: root
    - mode: '0755'

/srv/static:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'

/srv/static/index.png:
  file.managed:
    - source: salt://backend/index.png
    - user: root
    - group: root
    - mode: '0644'

systemd-reload:
  cmd.run:
  - name: systemctl --system daemon-reload
  - onchanges:
    - file: /lib/systemd/system/go_web.service

go_web:
  service.running:
    - watch:
      - file: /srv/static/index.png
      - file: /usr/bin/web-server
    - onchanges_in:
      - cmd: systemd-reload