FROM REGISTRY/FROM_IMAGE:VERSION
MAINTAINER Artem Golub <artemgolub@gmail.com>

ENTRYPOINT cp /app/config/nginx/nginx.conf /etc/nginx/nginx.conf && \
    rm -rf /etc/nginx/sites-enabled/* && \
    ln -s /app/config/nginx/frontend.conf /etc/nginx/sites-enabled/ && \
    /usr/sbin/nginx -c /etc/nginx/nginx.conf
