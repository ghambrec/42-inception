FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
		redis-server \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/redis.conf /etc/redis/redis.conf

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 6379

ENTRYPOINT ["init.sh"]
