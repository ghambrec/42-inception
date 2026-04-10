# User Documentation — Inception

This document explains how to use the Inception stack as an end user or administrator.

## What Services Are Provided

The stack runs the following services:

| Service | Description | Access |
|---|---|---|
| **WordPress** | Full CMS website with admin panel | `https://ghambrec.42.fr` |
| **Adminer** | Web interface to browse and manage the MariaDB database | `http://ghambrec.42.fr:8080` |
| **Gitea** | Self-hosted Git platform | `http://ghambrec.42.fr:3000` |
| **FTP** | FTP access to the WordPress file volume | Port 21 |
| **Static website** | A simple static HTML page | `https://ghambrec.42.fr/mywebsite` |

> **Note:** All traffic to the WordPress site goes through NGINX on port 443 (HTTPS only). The browser may show a certificate warning since a self-signed certificate is used — this is expected.

## Starting and Stopping the Project

### Start everything

```sh
make
```

This builds all Docker images (if not already built) and starts all containers in the background.

### Stop containers (keep data)

```sh
make stop
```

Containers are stopped but not removed. Data is preserved.

### Restart containers

```sh
make down
make
```

### Full reset (removes all data)

```sh
make fclean
```

> **Warning:** This deletes all containers, images, volumes, data directories, and generated secrets. Everything will be re-created from scratch on the next `make`.

## Accessing the Website and Administration Panel

### WordPress Site

Open your browser and navigate to:

```
https://ghambrec.42.fr
```

Accept the self-signed certificate warning if prompted.

### WordPress Admin Panel

```
https://ghambrec.42.fr/wp-admin
```

Log in with the WordPress admin credentials (see **Credentials** section below).

### Adminer (Database Manager)

```
http://ghambrec.42.fr:8080
```

- **System:** MySQL
- **Server:** `mariadb`
- **Username:** `wp_user`
- **Password:** contents of `secrets/db_user_password.txt`
- **Database:** `wordpress`

### Gitea

```
http://ghambrec.42.fr:3000
```

Log in with the Gitea admin credentials (see **Credentials** section below).

## Locating and Managing Credentials

All secrets are generated automatically by `make` and stored in the `secrets/` directory at the project root. Each file contains a randomly generated password.

| File | Used For |
|---|---|
| `secrets/db_user_password.txt` | MariaDB `wp_user` password |
| `secrets/db_root_password.txt` | MariaDB `root` password |
| `secrets/wp_admin_password.txt` | WordPress admin user password |
| `secrets/wp_user_password.txt` | WordPress regular user password |
| `secrets/ftp_user_password.txt` | FTP user password |
| `secrets/gitea_admin_password.txt` | Gitea admin password |

To read a password:

```sh
cat secrets/wp_admin_password.txt
```

> **Important:** The `secrets/` directory must never be committed to Git. It is already listed in `.gitignore`.

Non-sensitive configuration (usernames, domain name, database name) is in `srcs/.env`:

| Variable | Value |
|---|---|
| `DOMAIN_NAME` | `ghambrec.42.fr` |
| `MYSQL_USER` | `wp_user` |
| `WP_ADMIN_USER` | `superuser` |
| `WP_USER` | `ghambrec` |
| `FTP_USER` | `ftpuser` |
| `GITEA_ADMIN_USER` | `admin` |

## Checking That the Services Are Running

### List running containers

```sh
docker compose -f srcs/docker-compose.yml ps
```

All containers should have status `running`. MariaDB should also pass its healthcheck.

### View live logs

```sh
make logs
```

Or for a specific service:

```sh
docker compose -f srcs/docker-compose.yml logs -f nginx
docker compose -f srcs/docker-compose.yml logs -f wordpress
docker compose -f srcs/docker-compose.yml logs -f mariadb
```

### Quick health checks

| Check | Command |
|---|---|
| NGINX is listening on 443 | `curl -k https://ghambrec.42.fr` |
| MariaDB is accepting connections | `docker exec mariadb mariadb -u root -p$(cat secrets/db_root_password.txt) -e "SELECT 1"` |
| Redis is responding | `docker exec redis redis-cli ping` |
| Adminer is reachable | `curl http://localhost:8080` |
| Gitea is reachable | `curl http://localhost:3000` |
