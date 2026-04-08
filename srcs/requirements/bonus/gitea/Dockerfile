FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y \
		wget \
		curl \
		git \
	&& rm -rf /var/lib/apt/lists/*

RUN wget -q -O /usr/local/bin/gitea \
	"https://github.com/go-gitea/gitea/releases/download/v1.25.5/gitea-1.25.5-linux-amd64" && \
	chmod +x /usr/local/bin/gitea

RUN mkdir -p /var/lib/gitea /etc/gitea && \
	useradd -r -s /bin/bash -d /var/lib/gitea git && \
	chown -R git:git /var/lib/gitea /etc/gitea

COPY conf/app.ini /etc/gitea/app.ini
RUN chown git:git /etc/gitea/app.ini

COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3000

ENTRYPOINT ["init.sh"]
