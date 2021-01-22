FROM fedora:33

ARG PROXY_PORT
ARG PROXY_DOMAIN
ARG PROXY_COUNTRY
ARG PROXY_PROVINCE
ARG PROXY_CITY
ARG PROXY_DEPARTMENT
ARG PROXY_USER
ARG PROXY_USER_PASSWORD
ARG PROXY_CA_FILE

ENV PROXY_PORT "$PROXY_PORT"
ENV PROXY_DOMAIN "$PROXY_DOMAIN"
ENV PROXY_COUNTRY "$PROXY_COUNTRY"
ENV PROXY_PROVINCE "$PROXY_PROVINCE"
ENV PROXY_CITY "$PROXY_CITY"
ENV PROXY_DEPARTMENT "$PROXY_DEPARTMENT"
ENV PROXY_USER "$PROXY_USER"
ENV PROXY_USER_PASSWORD "$PROXY_USER_PASSWORD"
ENV PROXY_CA_FILE "$PROXY_CA_FILE"

RUN dnf update -y && \
    dnf clean all -y && \
    dnf install findutils -y && \
    dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    dnf install -y squid curl openssl httpd-tools && \
    mkdir -p /var/cache/squid

COPY Scripts/entrypoint.sh /usr/local/bin
COPY Scripts/initialize_certificate.sh /usr/local/bin
COPY Configuration/squid.conf /etc/squid/squid.conf
COPY Configuration/openssl.cnf /etc/squid/openssl.cnf

RUN chmod 750 /usr/local/bin/entrypoint.sh && \
    chmod 750 /usr/local/bin/initialize_certificate.sh

VOLUME /var/log/squid
VOLUME /var/cache/squid
VOLUME /etc/squid/ssl_cert
VOLUME /etc/squid/passwords

EXPOSE $PROXY_PORT

CMD sh /usr/local/bin/initialize_certificate.sh \
    "$PROXY_DOMAIN" "$PROXY_COUNTRY" "$PROXY_PROVINCE" "$PROXY_CITY" "$PROXY_DEPARTMENT" \
    "$PROXY_CA_FILE" && sh /usr/local/bin/entrypoint.sh "$PROXY_USER" "$PROXY_USER_PASSWORD"