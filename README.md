*This project has been created as part of the 42 curriculum by ghambrec.*

# Inception

## Description

Inception is a system administration project that uses **Docker Compose** to build and orchestrate a small infrastructure of services running in isolated containers. The goal is to set up a WordPress-based web stack from scratch — without pulling pre-built images from Docker Hub — using custom Dockerfiles and a shared Docker network.

### Design Choices

#### Virtual Machines vs Docker

| Virtual Machines | Docker Containers |
|---|---|
| Full OS per VM, heavy resource usage | Share the host kernel, lightweight |
| Slow boot times | Near-instant startup |
| Strong isolation via hypervisor | Process-level isolation via namespaces/cgroups |
| Suited for full OS environments | Suited for single-service workloads |

This project uses Docker because each service (NGINX, WordPress, MariaDB, etc.) is a focused, single-purpose process that benefits from container isolation without the overhead of a full VM.

#### Secrets vs Environment Variables

| Docker Secrets | Environment Variables |
|---|---|
| Stored on disk, mounted at `/run/secrets/` | Stored in memory / process environment |
| Not visible in `docker inspect` or image layers | Can leak into logs and image metadata |
| Suitable for passwords and credentials | Suitable for non-sensitive configuration |

Sensitive data (database passwords, WordPress credentials, FTP/Gitea passwords) are managed via **Docker secrets** (`secrets/` directory). Non-sensitive configuration (domain name, usernames, database name) is stored in `srcs/.env`.

#### Docker Network vs Host Network

| Docker Network (`bridge`) | Host Network |
|---|---|
| Containers communicate via DNS names | Containers share the host's network stack |
| Isolated from the host | No network isolation |
| Explicit port exposure required | All ports exposed by default |

This project uses a custom bridge network named `inception`. Containers resolve each other by service name (e.g., `wordpress`, `mariadb`, `redis`). Only required ports are exposed to the host (443, 21, 8080, 3000).

#### Docker Volumes vs Bind Mounts

| Docker Named Volumes | Bind Mounts |
|---|---|
| Managed by Docker | Directly maps a host path |
| Portable and declarative | Tightly coupled to host filesystem layout |
| Data persists across container restarts | Data persists but requires exact host path |

Named volumes are used for persistent data (`db`, `wordpress`, `gitea`, `gitea_config`). Their data is stored under `/home/ghambrec/data/` on the host. The subject explicitly requires named volumes — bind mounts are **not allowed** for the two main volumes.

## Services

| Service | Description | Port |
|---|---|---|
| **NGINX** | Reverse proxy, TLS termination (TLSv1.2/1.3 only) | 443 |
| **WordPress** | PHP-FPM application server | internal (9000) |
| **MariaDB** | Relational database for WordPress | internal (3306) |
| **Redis** | Object cache for WordPress | internal (6379) |
| **FTP** | FTP access to WordPress volume | 21, 30000–30009 |
| **Adminer** | Web-based database manager | 8080 |
| **Gitea** | Self-hosted Git service | 3000 |

## Instructions

### Prerequisites

- Docker and Docker Compose installed
- `make` available
- Add `ghambrec.42.fr` to `/etc/hosts` pointing to `127.0.0.1`

```sh
echo "127.0.0.1 ghambrec.42.fr" | sudo tee -a /etc/hosts
```

### Build and Start

```sh
make
```

This will:
1. Generate random secrets in `secrets/`
2. Create data directories under `/home/ghambrec/data/`
3. Build all Docker images and start the containers

### Stop / Clean

```sh
make stop     # Stop containers (keep data)
make down     # Stop and remove containers
make clean    # Remove containers + volumes + data
make fclean   # Full reset including images and secrets
```

### Access

- WordPress site: `https://ghambrec.42.fr`
- Adminer: `http://ghambrec.42.fr:8080`
- Gitea: `http://ghambrec.42.fr:3000`
- Static website: `https://ghambrec.42.fr/mywebsite`

## Resources

### Documentation

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/compose-file/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress CLI (WP-CLI)](https://wp-cli.org/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [Redis Documentation](https://redis.io/docs/)
- [Pure-FTPd Documentation](https://www.pureftpd.org/project/pure-ftpd/)
- [Gitea Documentation](https://docs.gitea.com/)
- [Adminer](https://www.adminer.org/)

### AI Usage

AI (Claude Code) was used during this project for the following tasks:

- Generating the required documentation files (`README.md`, `USER_DOC.md`, `DEV_DOC.md`) based on analysis of the source files and the subject requirements
- Answering conceptual questions about Docker networking, secrets management, and PHP-FPM configuration
- Reviewing init scripts for correctness and PID 1 compliance

All generated content was reviewed and understood before being included in the project.
