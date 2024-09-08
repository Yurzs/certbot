FROM certbot/certbot

USER root

ADD haproxy_hook_post /etc/letsencrypt/renewal-hooks/post/haproxy
RUN chmod +x /etc/letsencrypt/renewal-hooks/post/haproxy

RUN ln -s /etc/letsencrypt/renewal-hooks/post/haproxy /usr/bin/haproxy-hook

# Create dummy certificate
RUN openssl genrsa -out dummy.key 2048
RUN openssl req -new -key dummy.key -out dummy.csr -subj "/C=''/L=''/O=''/CN=''"
RUN openssl x509 -req -days 3650 -in dummy.csr -signkey dummy.key -out dummy.crt

RUN cat dummy.key dummy.crt > /etc/letsencrypt/dummy.pem

RUN rm dummy.key dummy.crt dummy.csr

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["certbot"]
