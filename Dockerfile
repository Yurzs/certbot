FROM certbot/certbot

USER root

ADD haproxy_hook_post /etc/letsencrypt/renewal-hooks/post/haproxy
RUN chmod +rx /etc/letsencrypt/renewal-hooks/post/haproxy
RUN chmod -w /etc/letsencrypt/renewal-hooks/post/haproxy

RUN ln -s /etc/letsencrypt/renewal-hooks/post/haproxy /usr/bin/haproxy-hook
