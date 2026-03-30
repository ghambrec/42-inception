FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
		php-fpm \
		php-mysql \
		curl && \
	rm -rf /var/lib/apt/lists/*

# get wp-cli -> wordpress command line tool
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x /usr/local/bin/wp

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 9000

ENTRYPOINT ["init.sh"]
