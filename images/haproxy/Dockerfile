FROM dockerfile/haproxy

RUN apt-get update && apt-get clean
RUN wget -O /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.7.1/confd-0.7.1-linux-amd64
RUN chmod 755 /usr/local/bin/confd
RUN mkdir -p /etc/confd/conf.d
RUN mkdir -p /etc/confd/templates

ADD boot.sh /usr/local/bin/boot.sh
RUN chmod 755 /usr/local/bin/boot.sh
ADD rsyslog.conf /etc/rsyslog.conf
ADD haproxy.toml /etc/confd/conf.d/haproxy.toml
ADD haproxy.cfg.tmpl /etc/confd/templates/haproxy.cfg.tmpl

CMD "boot.sh"
