zabbix-service:
  file.managed:
    - name: /usr/local/src/zabbix-2.4.6.tar.gz
    - source: salt://test/zabbix/zabbix-2.4.6.tar.gz
    - user: root
    - group: root
    - mode: 644
zabbix-cmd:
  cmd.run:
    - name: cd /usr/local/src/ && tar xf zabbix-2.4.6.tar.gz && cd zabbix-2.4.6 && ./configure --prefix=/usr/local/zabbix --enable-agent && make && make install
    - require:
      - file: zabbix-service
zabbix-file-conf:
  file.managed:
    - name: /usr/local/zabbix/etc/zabbix_agentd.conf
    - source: salt://test/zabbix/zabbix_agentd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      ip: server端ip地址
      hostname: server端ip地址
    - require:
      - file: zabbix-service
      - cmd: zabbix-cmd
zabbix-file-init:
  file.managed:
    - name: /etc/init.d/zabbix-agentd
    - source: salt://test/zabbix/zabbix-agentd
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: zabbix-service
      - cmd: zabbix-cmd
zabbix-file-sbin:
  file.managed:
    - name: /usr/sbin/zabbix_agentd
    - source: salt://test/zabbix/zabbix_agentd
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - names:
      - mkdir /opt/logs/zabbix/ -p
      - groupadd -g 506 zabbix
      - useradd -u 506 -g 506 -s /sbin/nologin zabbix
    - require:
      - file: zabbix-service
      - cmd: zabbix-cmd
      - file: zabbix-file-conf
      - file: zabbix-file-init
zabbix-file-chkconfig:
  cmd.run:
    - names:
      - chkconfig --add zabbix-agentd
      - chkconfig zabbix-agentd on
      - chown -R zabbix:zabbix /opt/logs/zabbix
  service.running:
    - name: zabbix-agentd
    - enable: True
    - require:
      - file: zabbix-file-init
      - file: zabbix-file-sbin
