FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
		php \
		php-mysql \
		php-cli \
		wget \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/adminer && \
	wget -q -O /var/www/adminer/index.php "https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php"

EXPOSE 8080

WORKDIR /var/www/adminer

CMD ["php", "-S", "0.0.0.0:8080"]
