FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		mariadb-server \
		mariadb-client && \
	rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["init.sh"]
