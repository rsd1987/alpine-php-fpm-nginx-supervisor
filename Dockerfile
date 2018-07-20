FROM alpine:latest

ADD https://storage.googleapis.com/v2ray-docker/v2ray /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/v2ctl /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geoip.dat /usr/bin/v2ray/
ADD https://storage.googleapis.com/v2ray-docker/geosite.dat /usr/bin/v2ray/
COPY config.json /etc/v2ray/config.json
RUN set -ex && \
    apk --no-cache add ca-certificates && \
    mkdir /var/log/v2ray/ &&\
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray

ENV PATH /usr/bin/v2ray:$PATH

RUN apk --update add nginx supervisor
RUN mkdir -p /etc/nginx
COPY  default /etc/nginx/sites-enabled/default
RUN mkdir -p /var/log/supervisor
RUN rm /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD nginx-supervisor.ini /etc/supervisor.d/nginx-supervisor.ini
EXPOSE 80 9000
CMD ["/usr/bin/supervisord"]
