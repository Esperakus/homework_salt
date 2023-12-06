nginx:
  pkg:
    - installed
  service.running:
    - watch:
      - pkg: nginx
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/conf.d/test.conf

/etc/nginx/conf.d/default.conf:
  file.absent

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://nginx/nginx.conf
    - user: nginx
    - group: nginx
    - mode: '0644'

/etc/nginx/conf.d/test.conf:
  file.managed:
    - source: salt://nginx/test.conf
    - user: nginx
    - group: nginx
    - mode: '0644'