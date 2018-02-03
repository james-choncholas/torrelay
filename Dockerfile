FROM alpine:latest

RUN echo "Installing dependancies" \
    && apk add --no-cache bash tor

ENV  KBS=500

RUN echo "Configuring tor" && \
    mkdir -p /etc/tor/ && \
    echo "ORPort 9001" >> /etc/tor/torrc && \
    echo "ExitPolicy reject *:*" >> /etc/tor/torrc && \
    echo "RelayBandwidthRate ${KBS} KB" >> /etc/tor/torrc && \
    echo "RelayBandwidthBurst $(( KBS * 2 )) KB" >> /etc/tor/torrc && \
    echo "CookieAuthentication 1" >> /etc/tor/torrc
#    echo "CookieAuthFileGroupReadable 1" >>/etc/tor/torrc && \
#    echo "CookieAuthFile /etc/tor/run/control.authcookie" >>/etc/tor/torrc && \
#    echo "DataDirectory /var/lib/tor" >>/etc/tor/torrc && \
#    echo "RunAsDaemon 0" >>/etc/tor/torrc && \
#    echo "User tor" >>/etc/tor/torrc && \
#    echo "AutomapHostsOnResolve 1" >>/etc/tor/torrc && \
#    echo "VirtualAddrNetworkIPv4 10.192.0.0/10" >>/etc/tor/torrc && \
#    echo "DNSPort 5353" >>/etc/tor/torrc && \
#    echo "SocksPort 0.0.0.0:9050 IsolateDestAddr" >>/etc/tor/torrc && \
#    echo "TransPort 0.0.0.0:9040" >>/etc/tor/torrc && \
#    echo "ControlSocket /etc/tor/run/control" >> /etc/tor/torrc && \
#    echo "ControlSocketsGroupWritable 1" >> /etc/tor/torrc && \
#    echo "ControlPort 9051" >> /etc/tor/torrc && \


RUN mkdir -p /var/lib/tor/.arm && echo "queries.useProc false" >> /var/lib/tor/.arm/armrc

#RUN echo "Allowing tor port access" && \
#    setcap CAP_NET_BIND_SERVICE=+eip /usr/bin/tor

RUN adduser -D -u 1000 anon && \
    chown -R anon:anon /etc/tor && \
    mkdir -p /etc/tor/run && \
    chown -Rh anon:anon /var/lib/tor /etc/tor/run && \
    chmod 0750 /etc/tor/run

EXPOSE 9001

RUN echo "tor -f /etc/tor/torrc" >> /home/anon/.bashrc

USER anon
WORKDIR /home/anon
ENTRYPOINT ["/bin/bash"]
