FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
		pure-ftpd  \
	&& rm -rf /var/lib/apt/lists/*

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 21
EXPOSE 30000-30009

ENTRYPOINT ["init.sh"]
