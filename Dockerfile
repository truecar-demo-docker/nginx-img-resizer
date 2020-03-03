FROM nginx:1.17.3-alpine

LABEL "com.datadoghq.ad.check_names"='["nginx"]'
LABEL "com.datadoghq.ad.init_configs"='[{}]'
LABEL "com.datadoghq.ad.instances"='[{"nginx_status_url": "http://%%host%%:%%port%%/nginx_status"}]'

RUN apk add --no-cache openssl nginx-mod-http-image-filter

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ADD include/  /etc/nginx/include/
ADD global.d/ /etc/nginx/global.d/

ENTRYPOINT ["/entrypoint.sh"]

CMD dockerize -template /etc/nginx/include/img-service.tmpl:/etc/nginx/include/img-service.conf nginx
