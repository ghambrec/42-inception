FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
		pure-ftpd  \
	&& rm -rf /var/lib/apt/lists/*

COPY conf/pure-ftpd.conf /etc/pure-ftpd/pure-ftpd.conf

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 21
EXPOSE 30000-30009

ENTRYPOINT ["init.sh"]
