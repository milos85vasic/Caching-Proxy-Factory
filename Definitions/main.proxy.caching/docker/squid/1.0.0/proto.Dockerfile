FROM fedora:33

ARG PROXY_PORT
ARG PROXY_DOMAIN

RUN dnf update -y && \
    dnf clean all -y && \
    dnf install findutils -y && \
    dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf install -y squid curl openssl && \
    mkdir -p /var/cache/squid

COPY Scripts/entrypoint.sh /usr/local/bin
COPY Scripts/initialize_certificate.sh /usr/local/bin
COPY Configuration/squid.conf /etc/squid/squid.conf
COPY Configuration/openssl.cnf /etc/squid/openssl.cnf

RUN chmod 750 /usr/local/bin/entrypoint.sh && \
    chmod 750 /usr/local/bin/initialize_certificate.sh

VOLUME /var/cache/squid
VOLUME /var/log/squid
VOLUME /etc/squid/ssl_cert

EXPOSE $PROXY_PORT

CMD sh /usr/local/bin/initialize_certificate.sh "$PROXY_DOMAIN" && \
    sh /usr/local/bin/entrypoint.sh