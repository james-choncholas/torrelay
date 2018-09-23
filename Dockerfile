FROM ubuntu:16.04

ENV NYX_REPO=https://git.torproject.org/nyx.git

RUN echo "Installing dependancies" && \
    apt-get update && \
    apt-get install -qy \
        bash \
        build-essential \
        tor \
        git \
        python \
        python-pip \
        python-dev

ENV KBS=1000

RUN echo "Configuring tor" && \
    mkdir -p /etc/tor/ && \
    echo "ORPort 9001" >> /etc/tor/torrc && \
    echo "ExitPolicy reject *:*" >> /etc/tor/torrc && \
    echo "RelayBandwidthRate ${KBS} KB" >> /etc/tor/torrc && \
    echo "RelayBandwidthBurst $(( KBS * 2 )) KB" >> /etc/tor/torrc && \
    echo "RunAsDaemon 0" >>/etc/tor/torrc && \
    echo "User anon" >>/etc/tor/torrc && \
    echo "CookieAuthentication 1" >> /etc/tor/torrc && \
    echo "CookieAuthFileGroupReadable 1" >>/etc/tor/torrc && \
    echo "CookieAuthFile /etc/tor/run/control.authcookie" >>/etc/tor/torrc && \
    echo "DataDirectory /var/lib/tor" >>/etc/tor/torrc && \
    echo "ControlSocket /etc/tor/run/control" >> /etc/tor/torrc && \
    echo "ControlSocketsGroupWritable 1" >> /etc/tor/torrc && \
    echo "ControlPort 9051" >> /etc/tor/torrc && \
    echo "Nickname bbgnwld" >> /etc/tor/torrc
#    echo "AutomapHostsOnResolve 1" >>/etc/tor/torrc && \
#    echo "VirtualAddrNetworkIPv4 10.192.0.0/10" >>/etc/tor/torrc && \
#    echo "DNSPort 5353" >>/etc/tor/torrc && \
#    echo "SocksPort 0.0.0.0:9050 IsolateDestAddr" >>/etc/tor/torrc && \
#    echo "TransPort 0.0.0.0:9040" >>/etc/tor/torrc && \

# To use NYX (aka arm)
RUN echo "Set up nyx" && \
    python -m pip install --upgrade pip && \
    pip install --upgrade virtualenv && \
    pip install stem && \
    git clone ${NYX_REPO} /usr/lib/nyx && \
    ln -sf /usr/lib/nyx/run_nyx /usr/bin/nyx

RUN useradd -ms /bin/bash anon && \
    mkdir -p /etc/tor/run && \
    chown -Rh anon. /var/lib/tor /etc/tor/run && \
    chmod 0750 /etc/tor/run && \
    rm -rf /tmp/*

# no need to EXPOSE port. Container must be started with -p 9001:9001
# to make the port public which implicitly EXPOSES the port to other
# docker containers.

VOLUME ["/etc/tor", "/var/lib/tor"]

COPY docker-entrypoint.sh /usr/bin/
ENTRYPOINT ["docker-entrypoint.sh"]
