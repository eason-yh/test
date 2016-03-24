zabbix-service:
  file.managed:
    - name: /usr/local/src/zabbix-2.4.6.tar.gz
    - source: salt://zabbix/zabbix-2.4.6.tar.gz
    - user: root
    - group: root
    - mode: 644
zabbix-cmd:
  cmd.run:
    - names:
      - mkdir /opt/logs/zabbix/ -p
      - groupadd -g 506 zabbix
      - useradd -u 506 -g 506 -s /sbin/nologin zabbix
      - chown -R zabbix:zabbix /opt/logs/zabbix
      - cd /usr/local/src/
      - tar xf zabbix-2.4.6.tar.gz && cd zabbix-2.4.6
      - ./configure --prefix=/usr/local/zabbix --enable-agent && make && make install
      - echo "ok" >> /tmp/zabbix-install.txt
    - require:
      - file: zabbix-service
zabbix-file-conf:
  file.managed:
    - name: /usr/local/zabbix/etc/zabbix_agentd.conf
    - source: salt://zabbix/zabbix_agentd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
      ip: {{ grains['fqdn_ip4'][0] }}
      hostname: {{ grains['localhost'] }}
    - require:
      - file: zabbix-service
      - cmd: zabbix-cmd
zabbix-file-init:
  file.managed:
    - name: /etc/init.d/zabbix-agentd
    - source: salt://zabbix/zabbix-agentd
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: zabbix-service
      - cmd: zabbix-cmd
zabbix-file-sbin:
  file.managed:
    - name: /usr/sbin/zabbix_agentd
    - source: salt://zabbix/zabbix_agentd
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: zabbix-service
      - cmd: zabbix-cmd
zabbix-file-chkconfig:
  cmd.run:
    - names:
      - chkconfig --add zabbix-agentd
      - chkconfig zabbix-agentd on
    - require:
      - file: zabbix-file-init
      - file: zabbix-file-sbin
