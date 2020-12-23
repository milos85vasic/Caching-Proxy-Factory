FROM centos:8

ARG PROXY_PORT

RUN dnf update -y && \
    dnf clean all -y && \
    dnf install -y squid curl openssl && \
    mkdir -p /etc/squid/ssl_cert && \
    mkdir -p /var/cache/squid

COPY Scripts/entrypoint.sh /usr/local/bin
COPY Configuration/squid.conf /etc/squid/squid.conf
COPY Configuration/openssl.cnf /etc/squid/ssl_cert/openssl.cnf

RUN chmod 755 /usr/local/bin/entrypoint.sh

RUN mkdir /etc/squid/ssl_cert
COPY openssl.cnf /etc/squid/ssl_cert/openssl.cnf

VOLUME /var/cache/squid
VOLUME /var/log/squid
VOLUME /etc/squid/ssl_cert

EXPOSE $PROXY_PORT
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]