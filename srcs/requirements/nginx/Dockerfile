FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		nginx \
		openssl \
		gettext-base \
	&& rm -rf /var/lib/apt/lists/*


RUN openssl req -x509 -nodes -days 365 \
	-newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx.key \
	-out	/etc/ssl/certs/nginx.crt \
	-subj	"/C=DE/ST=BW/O=42/CN=localhost"


COPY conf/nginx.conf /etc/nginx/templates/nginx.conf

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# BONUS (static website)
COPY mywebsite/index.html /var/www/html/mywebsite/index.html

EXPOSE 443

ENTRYPOINT ["init.sh"]
