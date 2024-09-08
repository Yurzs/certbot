FROM certbot/certbot

USER root

ADD haproxy_hook_post /etc/letsencrypt/renewal-hooks/post/haproxy
RUN chmod +x /etc/letsencrypt/renewal-hooks/post/haproxy

RUN ln -s /etc/letsencrypt/renewal-hooks/post/haproxy /usr/bin/haproxy-hook

ADD entrypoint.sh /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["certbot"]
