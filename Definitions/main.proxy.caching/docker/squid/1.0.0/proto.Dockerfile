FROM centos:8

ARG PROXY_PORT

RUN dnf update -y && \
    dnf clean all -y && \
    dnf install -y squid curl openssl && \
    mkdir -p /var/cache/squid

VOLUME /var/cache/squid
VOLUME /var/log/squid
VOLUME /etc/squid/ssl_cert

COPY Scripts/entrypoint.sh /usr/local/bin
COPY Scripts/initialize_certificate.sh /usr/local/bin
COPY Configuration/squid.conf /etc/squid/squid.conf
COPY Configuration/openssl.cnf /etc/squid/ssl_cert/openssl.cnf

RUN chmod 750 /usr/local/bin/entrypoint.sh && \
    chmod 750 /usr/local/bin/initialize_certificate.sh

EXPOSE $PROXY_PORT

CMD sh /usr/local/bin/initialize_certificate.sh && \
    sh /usr/local/bin/entrypoint.sh