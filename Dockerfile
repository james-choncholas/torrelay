FROM alpine:latest

ENV NYX_REPO=https://git.torproject.org/nyx.git

RUN echo "Installing dependancies" \
    && apk --no-cache --no-progress update \
    && apk --no-cache --no-progress add bash tor git python py-pip

ENV  KBS=1000

RUN echo "Configuring tor" && \
    mkdir -p /etc/tor/ && \
    echo "ORPort 9001" >> /etc/tor/torrc && \
    echo "ExitPolicy reject *:*" >> /etc/tor/torrc && \
    echo "RelayBandwidthRate ${KBS} KB" >> /etc/tor/torrc && \
    echo "RelayBandwidthBurst $(( KBS * 2 )) KB" >> /etc/tor/torrc && \
    echo "RunAsDaemon 0" >>/etc/tor/torrc && \
    echo "CookieAuthentication 1" >> /etc/tor/torrc
#    echo "User anon" >>/etc/tor/torrc && \
#    echo "CookieAuthFileGroupReadable 1" >>/etc/tor/torrc && \
#    echo "CookieAuthFile /etc/tor/run/control.authcookie" >>/etc/tor/torrc && \
#    echo "DataDirectory /var/lib/tor" >>/etc/tor/torrc && \
#    echo "AutomapHostsOnResolve 1" >>/etc/tor/torrc && \
#    echo "VirtualAddrNetworkIPv4 10.192.0.0/10" >>/etc/tor/torrc && \
#    echo "DNSPort 5353" >>/etc/tor/torrc && \
#    echo "SocksPort 0.0.0.0:9050 IsolateDestAddr" >>/etc/tor/torrc && \
#    echo "TransPort 0.0.0.0:9040" >>/etc/tor/torrc && \
#    echo "ControlSocket /etc/tor/run/control" >> /etc/tor/torrc && \
#    echo "ControlSocketsGroupWritable 1" >> /etc/tor/torrc && \
#    echo "ControlPort 9051" >> /etc/tor/torrc && \

RUN echo "Set up nyx" && \
    pip install stem && \
    git clone ${NYX_REPO} /usr/lib/nyx && \
    ln -sf /usr/lib/nyx/run_nyx /usr/bin/nyx

RUN adduser -D -u 1000 anon && \
    chown -R anon:anon /etc/tor && \
    mkdir -p /etc/tor/run && \
    chown -Rh anon:anon /var/lib/tor /etc/tor/run && \
    chmod 0750 /etc/tor/run

# no need to EXPOSE port. Container must be started with -p 9001:9001
# to make the port public which implicitly EXPOSES the port to other 
# docker containers.

RUN echo "tor -f /etc/tor/torrc &" >> /home/anon/.bashrc

USER anon
WORKDIR /home/anon
ENTRYPOINT ["/bin/bash"]
